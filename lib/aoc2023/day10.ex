defmodule Aoc2023.Day10 do
  def input() do
    File.read!("input/day10.txt")
  end

  def part1(data) do
    {start, map} = parse_data(data)

    path = find_cycle_from(map, start)

    div(length(path), 2)
  end

  def part2(data) do
    {start, map} = parse_data(data)

    # Take into account gaps between pipes by multiplying everything by 2
    #  - multiply path by 2 and add connecting pipes
    #  - map is not needed, we only care about the area inside the path
    path =
      map
      |> find_cycle_from(start)
      |> scale_path()

    # Determine maximum coordinates (minimum and maximum row, col)
    {top_left, bottom_right} = extents(path)

    # Find area on one side of path. If it hits edge, it's outside and use the other side.
    {side_a_start, side_b_start} = pick_sides(path)

    {:inside, inside} =
      case points(path, side_a_start, {top_left, bottom_right}) do
        :outside -> points(path, side_b_start, {top_left, bottom_right})
        i -> i
      end

    # Consider only even coordinates inside the path after multiplying by 2
    inside = keep_even_points(inside)

    length(inside)
  end

  defp parse_data(lines) do
    map =
      lines
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&Aoc2023.empty_string?/1)
      |> Enum.map(&String.codepoints/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, row}, map ->
        line
        |> Enum.with_index()
        |> Enum.reduce(map, fn {char, col}, map ->
          pipe = parse_pipe_at(char, {row, col})
          Map.put(map, {row, col}, pipe)
        end)
      end)

    start = find_start_position(map)
    start_with_connections = find_connections_from_start(map, start)
    map = Map.put(map, start, start_with_connections)

    {start, map}
  end

  defp parse_pipe_at(".", _), do: :ground
  defp parse_pipe_at("|", {row, col}), do: {:pipe, {row - 1, col}, {row + 1, col}}
  defp parse_pipe_at("-", {row, col}), do: {:pipe, {row, col - 1}, {row, col + 1}}
  defp parse_pipe_at("L", {row, col}), do: {:pipe, {row - 1, col}, {row, col + 1}}
  defp parse_pipe_at("J", {row, col}), do: {:pipe, {row - 1, col}, {row, col - 1}}
  defp parse_pipe_at("7", {row, col}), do: {:pipe, {row, col - 1}, {row + 1, col}}
  defp parse_pipe_at("F", {row, col}), do: {:pipe, {row + 1, col}, {row, col + 1}}
  defp parse_pipe_at("S", _), do: :start

  defp find_start_position(map) do
    Enum.find_value(map, fn
      {k, :start} -> k
      {k, {:start, _, _}} -> k
      {_, _} -> false
    end)
  end

  defp find_connections_from_start(map, start) do
    [start_1, start_2] =
      Enum.flat_map(map, fn
        {k, {:pipe, ^start, _}} -> [k]
        {k, {:pipe, _, ^start}} -> [k]
        _ -> []
      end)

    {:start, start_1, start_2}
  end

  defp find_cycle_from(map, start) do
    find_cycle_from(map, start, MapSet.new([start]), [start])
  end

  defp find_cycle_from(map, current, seen, path) do
    case next_node(map, current, seen) do
      :done -> path
      next -> find_cycle_from(map, next, MapSet.put(seen, next), [next | path])
    end
  end

  defp next_node(map, current, seen) do
    {_, a, b} = Map.get(map, current)

    case {MapSet.member?(seen, a), MapSet.member?(seen, b)} do
      {true, true} -> :done
      {true, _} -> b
      {_, true} -> a
      {false, false} -> a
    end
  end

  defp scale_path(path) do
    path =
      for {x, y} <- path do
        {x * 2, y * 2}
      end

    interpolate_path(path, [])
  end

  defp interpolate_path([last], acc) do
    first = List.last(acc)

    Enum.reverse([middle_node(first, last), last | acc])
  end

  defp interpolate_path([a, b | rest], acc) do
    interpolate_path([b | rest], [middle_node(a, b), a | acc])
  end

  defp middle_node({x1, y}, {x2, y}) when x1 == x2 + 2, do: {x1 - 1, y}
  defp middle_node({x1, y}, {x2, y}) when x1 == x2 - 2, do: {x1 + 1, y}
  defp middle_node({x, y1}, {x, y2}) when y1 == y2 + 2, do: {x, y1 - 1}
  defp middle_node({x, y1}, {x, y2}) when y1 == y2 - 2, do: {x, y1 + 1}

  defp extents(path) do
    {{_, y0}, {_, y1}} = Enum.min_max_by(path, fn {_, y} -> y end)
    {{x0, _}, {x1, _}} = Enum.min_max_by(path, fn {x, _} -> x end)

    {{x0, y0}, {x1, y1}}
  end

  # Only need start and next: the path is scaled, so next point is always either horizontal or vertical
  defp pick_sides([{x, y1}, {x, y2} | _]) when abs(y1 - y2) == 1 do
    {{x - 1, y2}, {x + 1, y2}}
  end

  defp pick_sides([{x1, y}, {x2, y} | _]) when abs(x1 - x2) == 1 do
    {{x2, y - 1}, {x2, y + 1}}
  end

  defp points(path, start, extent) do
    points([start], extent, MapSet.new([start | path]), MapSet.new())
  end

  defp points([], _, _, ps), do: {:inside, ps}

  defp points([{x, y} | _], {{x_min, y_min}, {x_max, y_max}}, _, _)
       when x < x_min or x > x_max or y < y_min or y > y_max,
       do: :outside

  defp points([p | rest], extent, seen, ps) do
    seen = MapSet.put(seen, p)
    next = connected_points(p, seen)

    points(next ++ rest, extent, seen, MapSet.put(ps, p))
  end

  defp connected_points({x, y}, seen) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.reject(fn p -> MapSet.member?(seen, p) end)
  end

  defp keep_even_points(points) do
    Enum.filter(points, fn {x, y} -> rem(x, 2) == 0 && rem(y, 2) == 0 end)
  end
end
