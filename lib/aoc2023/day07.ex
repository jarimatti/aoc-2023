defmodule Aoc2023.Day07 do
  def input() do
    File.read!("input/day07.txt")
  end

  def part1(data) do
    data
    |> parse_hands_and_bids()
    |> Enum.sort_by(fn {t, h, _b} -> {t, h} end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, _, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  defp parse_hands_and_bids(string) do
    string
    |> String.split("\n")
    |> Enum.reject(&empty_string?/1)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {hand, bid} ->
      {score(hand), hand, bid}
    end)
  end

  defp empty_string?(""), do: true
  defp empty_string?(_), do: false

  defp parse_line(line) do
    [cards_string, bid_string] = String.split(line)

    cards = parse_cards(cards_string)
    bid = String.to_integer(bid_string)

    {cards, bid}
  end

  defp parse_cards(string) do
    for c <- String.codepoints(string) do
      case c do
        "2" -> 1
        "3" -> 2
        "4" -> 3
        "5" -> 4
        "6" -> 5
        "7" -> 6
        "8" -> 7
        "9" -> 8
        "T" -> 9
        "J" -> 10
        "Q" -> 11
        "K" -> 12
        "A" -> 13
      end
    end
  end

  defp score(hand) do
    counts =
      hand
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort(:desc)

    case counts do
      [5] -> 600
      [4, 1] -> 500
      [3, 2] -> 400
      [3, 1, 1] -> 300
      [2, 2, 1] -> 200
      [2, 1, 1, 1] -> 100
      [1, 1, 1, 1, 1] -> 10 # The high card is _type_ so we ignore what was the highest card!
    end
  end
end
