defmodule Aoc2023.Day15 do
  alias Aoc2023.Day15.Apparatus

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

  def part2(data) do
    # stub
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.reduce(Apparatus.new(), fn s, app ->
      {box_id, op} = parse_instruction(s)

      Apparatus.apply(app, box_id, op)
    end)
    |> Apparatus.focusing_power()
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

  defp parse_instruction(s) do
    case String.split(s, ~r/[-=]/) do
      [label, ""] -> {hash(label), {:remove, label}}
      [label, fl] -> {hash(label), {:upsert, label, String.to_integer(fl)}}
    end
  end
end
