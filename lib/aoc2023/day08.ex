defmodule Aoc2023.Day08 do
  def input() do
    File.read!("input/day08.txt")
  end

  def part1(data) do
    {instructions, map} = parse_data(data)

    instructions
    |> Stream.cycle()
    |> Stream.transform("AAA", fn
      _, "ZZZ" ->
        {:halt, "ZZZ"}

      dir, vertex ->
        edges = :digraph.out_edges(map, vertex)

        {_, _, to, _} =
          edges
          |> Enum.map(fn e -> :digraph.edge(map, e) end)
          |> Enum.find(fn
            {_, _, _, [^dir]} -> true
            _ -> false
          end)

        {[to], to}
    end)
    |> Enum.count()
  end

  def part2(_data) do
    # stub
    0
  end

  defp parse_data(data) do
    [instruction_string | map_strings] =
      data
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&Aoc2023.empty_string?/1)

    instructions = parse_instructions(instruction_string)
    map = parse_map(map_strings)

    {instructions, map}
  end

  defp parse_instructions(s) do
    for c <- String.codepoints(s) do
      case c do
        "L" -> :left
        "R" -> :right
      end
    end
  end

  defp parse_map(map_strings) do
    graph = :digraph.new()

    map_strings
    |> Enum.map(&parse_map_line/1)
    |> Enum.reduce(graph, fn {from, left, right}, graph ->
      :digraph.add_vertex(graph, from)
      :digraph.add_vertex(graph, left)
      :digraph.add_vertex(graph, right)

      :digraph.add_edge(graph, from, left, [:left])
      :digraph.add_edge(graph, from, right, [:right])

      graph
    end)
  end

  defp parse_map_line(line) do
    [node, rest] = String.split(line, " = ", parts: 2)

    [left, right] =
      rest
      |> String.trim_leading("(")
      |> String.trim_trailing(")")
      |> String.split(", ", parts: 2)

    {node, left, right}
  end
end
