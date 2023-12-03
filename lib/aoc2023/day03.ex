defmodule Aoc2023.Day03 do
  def input() do
    File.read!("input/day03.txt")
  end

  def part1(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      elements_with_positions = parse_elements_with_positions(line, y)
      Map.merge(acc, elements_with_positions)
    end)
    |> numbers_next_to_symbol()
    |> Enum.sum()

    # 529408 is too high
  end

  defp parse_elements_with_positions(line, y) do
    pattern = ~r/([[:digit:]]+|[^\.]{1})/

    start_and_lenghts = Regex.scan(pattern, line, capture: :first, return: :index)

    Enum.map(start_and_lenghts, fn [{x, len}] ->
      substring = String.slice(line, x, len)
      element = parse_element(substring)

      {{{x, len}, y}, element}
    end)
    |> Map.new()
  end

  defp parse_element(elem) do
    case Integer.parse(elem) do
      {number, ""} -> number
      :error -> elem
    end
  end

  defp symbol_by_position(map) do
    map
    |> Enum.flat_map(fn
      {_, v} when is_integer(v) -> []
      {{{x, 1}, y}, v} -> [{{x, y}, v}]
    end)
    |> Map.new()
  end

  defp numbers_next_to_symbol(map) do
    symbol_positions =
      map
      |> symbol_by_position()
      |> Map.keys()
      |> MapSet.new()

    Enum.flat_map(map, fn
      {pos, v} when is_integer(v) ->
        adjacent_to_symbol =
          pos
          |> neighbours()
          |> Enum.any?(fn pos -> MapSet.member?(symbol_positions, pos) end)

        case adjacent_to_symbol do
          true -> [v]
          false -> []
        end

      _ ->
        []
    end)
  end

  defp neighbours({{x, len}, y}) do
    for x <- (x - 1)..(x + len), y <- (y - 1)..(y + 1) do
      {x, y}
    end
  end
end
