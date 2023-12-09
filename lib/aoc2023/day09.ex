defmodule Aoc2023.Day09 do
  def part1(data) do
    parse_data(data)
  end

  defp parse_data(data) do
    data
    |> String.split("\n")
    |> Enum.reject(&Aoc2023.empty_string?/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
  end
end
