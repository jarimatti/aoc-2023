defmodule Aoc2023.Day13 do
  def input() do
    File.read!("input/day13.txt")
  end

  def part1(data) do
    data
    |> parse_data()
    |> Enum.map(fn map ->
      {map, transpose(map)}
    end)
    |> Enum.map(&mirror_position/1)
    |> Enum.map(&summarize/1)
    |> Enum.sum()
  end

  defp parse_data(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_by(&Aoc2023.empty_string?/1)
    |> Enum.reject(fn x -> x == [""] end)
  end

  defp transpose(map) do
    map
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join/1)
  end

  defp mirror_position({rows, cols}) do
    {mirroring_row(rows), mirroring_row(cols)}
  end

  defp mirroring_row(rows) do
    mirroring_rows(rows, [], 1)
  end

  defp mirroring_rows([a], [a | _], x), do: x
  defp mirroring_rows([_], _, _), do: nil

  defp mirroring_rows([a | rest], aa, n) do
    next = [a | aa]

    is_mirror =
      next
      |> Enum.zip(rest)
      |> Enum.all?(fn {x, y} -> x == y end)

    case is_mirror do
      true -> n
      false -> mirroring_rows(rest, next, n + 1)
    end
  end

  defp summarize({row, nil}), do: row * 100
  defp summarize({nil, col}), do: col
end
