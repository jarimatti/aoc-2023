defmodule Aoc2023.Day14 do
  def part1(data) do
    {map, ranges} = parse_data(data)

    IO.puts(format_map(map, ranges))

    map
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

  defp format_map(map, {x_range, y_range}) do
    for y <- y_range do
      for x <- x_range do
        format_element(Map.get(map, {x, y}))
      end
    end |> Enum.intersperse("\n")
  end

  defp format_element(nil), do: "."
  defp format_element(:block), do: "#"
  defp format_element(:ball), do: "O"
end
