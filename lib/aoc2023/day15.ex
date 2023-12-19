defmodule Aoc2023.Day15 do
  def input() do
    File.read!("input/day15.txt")
  end

  def part1(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def hash(s) do
    hash(s, 0)
  end

  defp hash(<<>>, h), do: h
  defp hash(<<c, rest::binary>>, h) do
    hash(rest, char_hash(c + h))
  end

  defp char_hash(c) do
    rem(c * 17, 256)
  end
end
