defmodule Aoc2023.Day14 do
  def part1(data) do
    {map, ranges} = parse_data(data)

    map
    |> tilt_north(ranges)
  end

  defp parse_data(data) do
    map =
      data
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, acc ->
        line
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, x}, acc ->
          case parse_char(char) do
            nil -> acc
            value -> Map.put(acc, {x, y}, value)
          end
        end)
      end)

    keys = Map.keys(map)

    max_x =
      keys
      |> Enum.map(&elem(&1, 0))
      |> Enum.max()

    max_y =
      keys
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    {map, {0..max_x, 0..max_y}}
  end

  defp parse_char("."), do: nil
  defp parse_char("#"), do: :block
  defp parse_char("O"), do: :ball

  def format_map(map, {x_range, y_range}) do
    for y <- y_range do
      for x <- x_range do
        format_element(Map.get(map, {x, y}))
      end
    end
    |> Enum.intersperse("\n")
  end

  defp format_element(nil), do: "."
  defp format_element(:block), do: "#"
  defp format_element(:ball), do: "O"

  defp tilt_north(map, {x_range, y_range}) do
    # Go through each column
    # Travel from top to bottom.
    # Track latest free slot (first unfilled one) and if encountering ball, move it there.
    # If encountering block or ball, start to move the free slot.

    {map, _} =
      Enum.reduce(x_range, {map, nil}, fn x, {map, _} ->
        Enum.reduce(y_range, {map, :search_free}, fn
          y, {map, :search_free} ->
            case Map.get(map, {x, y}) do
              nil -> {map, y}
              _ -> {map, :search_free}
            end

          y, {map, latest_free_y} ->
            case Map.get(map, {x, y}) do
              nil ->
                {map, latest_free_y}

              :ball ->
                from = {x, y}
                to = {x, latest_free_y}
                {move_ball(map, from, to), latest_free_y + 1}

              :block ->
                {map, :search_free}
            end
        end)
      end)

    map
  end

  defp move_ball(map, from, to) do
    map
    |> Map.put(to, :ball)
    |> Map.delete(from)
  end
end
