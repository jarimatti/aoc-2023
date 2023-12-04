defmodule Aoc2023.Day04 do
  def input() do
    File.read!("input/day04.txt")
  end

  def part1(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&empty?/1)
    |> Enum.map(&parse_card/1)
    |> Enum.map(&card_score/1)
    |> Enum.sum()
  end

  def part2(data) do
    0
  end

  defp empty?(""), do: true
  defp empty?(s) when is_binary(s), do: false

  defp parse_card(line) do
    [_, numbers] = String.split(line, ":")
    [winning_numbers, card_numbers] = String.split(numbers, " | ")

    w = parse_numbers(winning_numbers)
    c = parse_numbers(card_numbers)

    {MapSet.new(w), MapSet.new(c)}
  end

  defp parse_numbers(numbers_string) do
    numbers_string
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp card_score({winning, card}) do
    same_number_count =
      winning
      |> MapSet.intersection(card)
      |> MapSet.size()

    case same_number_count do
      0 -> 0
      n -> 2 ** (n - 1)
    end
  end
end
