defmodule Aoc2023.Day10 do
  def input() do
    File.read!("input/day10.txt")
  end

  def part1(data) do
    {start, map} = parse_data(data)

    path = find_cycle_from(map, start)

    div(length(path), 2)
  end

  def part2(_data) do
    # stub
    0
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
end
