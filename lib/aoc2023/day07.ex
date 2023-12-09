defmodule Aoc2023.Day07 do
  def input() do
    File.read!("input/day07.txt")
  end

  def part1(data) do
    data
    |> parse_hands_and_bids()
    |> Enum.map(fn {hand, bid} ->
      {score(hand), hand, bid}
    end)
    |> sort_and_calculate_score()
  end

  def part2(data) do
    data
    |> parse_hands_and_bids()
    |> Enum.map(fn {hand, bid} ->
      hand = remap_joker(hand)
      {score_with_joker(hand), hand, bid}
    end)
    |> sort_and_calculate_score()
  end

  defp sort_and_calculate_score(hands) do
    hands
    |> Enum.sort_by(fn {t, h, _b} -> {t, h} end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, _, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  defp parse_hands_and_bids(string) do
    string
    |> String.split("\n")
    |> Enum.reject(&Aoc2023.empty_string?/1)
    |> Enum.map(&parse_line/1)
  end

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
      # The high card is _type_ so we ignore what was the highest card!
      [1, 1, 1, 1, 1] -> 10
    end
  end

  defp score_with_joker(hand) do
    all_counts = Enum.frequencies(hand)

    jokers = all_counts[0] || 0

    counts =
      all_counts
      |> Map.delete(0)
      |> Map.values()
      |> Enum.sort(:desc)

    max_count =
      case counts do
        [] -> 0
        c -> Enum.max(c)
      end

    case {counts, jokers, max_count + jokers} do
      {_, _, 5} -> 600
      {_, _, 4} -> 500
      {[3, 2], 0, _} -> 400
      {[3, 1], 1, _} -> 400
      {[2, 2], 1, _} -> 400
      {[3, 1, 1], 0, _} -> 300
      {[2, 1, 1], 1, _} -> 300
      {[1, 1, 1], 2, _} -> 300
      {[2, 2, 1], 0, _} -> 200
      {[2, 1, 1, 1], 0, _} -> 100
      {[1, 1, 1, 1], 1, _} -> 100
      # The high card is _type_ so we ignore what was the highest card!
      {[1, 1, 1, 1, 1], 0, _} -> 10
    end
  end

  defp remap_joker(cards) do
    Enum.map(cards, fn
      10 -> 0
      c -> c
    end)
  end
end
