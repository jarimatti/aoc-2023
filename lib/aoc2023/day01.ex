defmodule Aoc2023.Day01 do
  def input() do
    File.read!("input/day01.txt")
  end

  def part1(data) do
    data
    |> String.split()
    |> Enum.map(fn l -> parse_line(l, only_digits()) end)
    |> Enum.sum()
  end

  def part2(data) do
    data
    |> String.split()
    |> Enum.map(fn l -> parse_line(l, digits_and_words()) end)
    |> Enum.sum()
  end

  defp parse_line(line, pattern) do
    line
    |> digits(pattern)
    |> first_and_last()
    |> Integer.undigits()
  end

  def only_digits() do
    ~r/([[:digit:]]{1})/
  end

  def digits_and_words() do
    ~r/([[:digit:]]{1}|on(?=e)|tw(?=o)|thre(?=e)|four|fiv(?=e)|six|seven|eigh(?=t)|nin(?=e))/
  end

  defp digits(line, pattern) do
    Regex.scan(pattern, line, capture: :first)
    |> List.flatten()
    |> Enum.map(&digit/1)
  end

  defp digit("1"), do: 1
  defp digit("on"), do: 1
  defp digit("2"), do: 2
  defp digit("tw"), do: 2
  defp digit("3"), do: 3
  defp digit("thre"), do: 3
  defp digit("4"), do: 4
  defp digit("four"), do: 4
  defp digit("5"), do: 5
  defp digit("fiv"), do: 5
  defp digit("6"), do: 6
  defp digit("six"), do: 6
  defp digit("7"), do: 7
  defp digit("seven"), do: 7
  defp digit("8"), do: 8
  defp digit("eigh"), do: 8
  defp digit("9"), do: 9
  defp digit("nin"), do: 9

  defp first_and_last(digits) do
    [List.first(digits), List.last(digits)]
  end
end
