defmodule Aoc2023.Day04 do
  def input() do
    File.read!("input/day04.txt")
  end

  def part1(data) do
    data
    |> parse_cards()
    |> Map.values()
    |> Enum.map(&matching_number_count/1)
    |> Enum.map(&card_score/1)
    |> Enum.sum()
  end

  def part2(data) do
    card_and_count =
      data
      |> parse_cards()
      |> Map.new(fn {k, v} -> {k, matching_number_count(v)} end)

    stack = Map.keys(card_and_count)

    total_cards(stack, 0, card_and_count)
  end

  defp parse_cards(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&empty?/1)
    |> Enum.map(&parse_card/1)
    |> Map.new()
  end

  defp empty?(""), do: true
  defp empty?(s) when is_binary(s), do: false

  defp parse_card(line) do
    [id_string, numbers] = String.split(line, ":")

    id =
      case String.split(id_string) do
        ["Card", s] -> String.to_integer(s)
      end

    [winning_numbers, card_numbers] = String.split(numbers, " | ")

    w = parse_numbers(winning_numbers)
    c = parse_numbers(card_numbers)

    {id, {MapSet.new(w), MapSet.new(c)}}
  end

  defp parse_numbers(numbers_string) do
    numbers_string
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp matching_number_count({winning, card}) do
    winning
    |> MapSet.intersection(card)
    |> MapSet.size()
  end

  defp card_score(0), do: 0
  defp card_score(n) when n > 0, do: 2 ** (n - 1)

  defp total_cards([], n, _), do: n

  defp total_cards([id | rest], n, card_counts) do
    matching_numbers = Map.get(card_counts, id)
    next = next_cards(id, matching_numbers)
    total_cards(next ++ rest, n + 1, card_counts)
  end

  defp next_cards(_, 0), do: []

  defp next_cards(current, count) when count > 0 do
    for step <- 1..count do
      current + step
    end
  end
end
