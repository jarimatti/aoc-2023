defmodule Aoc2023.Day11 do
  def input() do
    File.read!("input/day11.txt")
  end

  def part1(data) do
    solve(data, 2)
  end

  def part2(data) do
    solve(data, 1_000_000)
  end

  def solve(data, factor) do
    data
    |> parse_data()
    |> expand_empty_rows_and_cols(factor)
    |> all_pairs()
    |> Enum.map(fn {a, b} -> shortest_distance(a, b) end)
    |> Enum.sum()
  end

  defp parse_data(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&Aoc2023.empty_string?/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {"#", x} -> [{x, y}]
        _ -> []
      end)
    end)
  end

  defp expand_empty_rows_and_cols(galaxies, factor) do
    xs = galaxies |> Enum.map(fn {x, _} -> x end) |> MapSet.new()
    ys = galaxies |> Enum.map(fn {_, y} -> y end) |> MapSet.new()

    x_empty = MapSet.difference(MapSet.new(0..Enum.max(xs)), xs)
    y_empty = MapSet.difference(MapSet.new(0..Enum.max(ys)), ys)

    galaxies
    |> Enum.map(fn {x, y} ->
      x_delta = Enum.count(x_empty, fn xe -> xe < x end) * (factor - 1)
      y_delta = Enum.count(y_empty, fn ye -> ye < y end) * (factor - 1)

      {x + x_delta, y + y_delta}
    end)
  end

  defp all_pairs(galaxies) do
    for a <- galaxies, b <- galaxies, a < b do
      {a, b}
    end
  end

  defp shortest_distance({x0, y0}, {x1, y1}) do
    abs(x0 - x1) + abs(y0 - y1)
  end
end
