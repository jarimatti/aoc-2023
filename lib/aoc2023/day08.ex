defmodule Aoc2023.Day08 do
  def input() do
    File.read!("input/day08.txt")
  end

  def part1(data) do
    {instructions, map} = parse_data(data)

    run(instructions, map, ["AAA"], &reached_goal1/1)
  end

  def part2(data) do
    {instructions, map} = parse_data(data)

    vertices = :digraph.vertices(map)
    start_vertices = Enum.filter(vertices, fn s -> String.ends_with?(s, "A") end)

    run(instructions, map, start_vertices, &reached_goal2/1)
  end

  defp run(instructions, map, start_vertices, reached_goal) do
    instructions
    |> Stream.cycle()
    |> Stream.transform(start_vertices, fn dir, vertices ->
      case reached_goal.(vertices) do
        true ->
          {:halt, vertices}

        false ->
          new_vertices =
            vertices
            |> Task.async_stream(fn v -> step_vertex(map, v, dir) end)
            |> Enum.map(fn {:ok, x} -> x end)

          {[1], new_vertices}
      end
    end)
    |> Enum.count()
  end

  def reached_goal1(["ZZZ"]), do: true
  def reached_goal1([_]), do: false

  def reached_goal2(vertices) do
    Enum.all?(vertices, fn s -> String.ends_with?(s, "Z") end)
  end

  defp step_vertex(map, vertex, dir) do
    edges = :digraph.out_edges(map, vertex)

    {_, _, to, _} =
      edges
      |> Enum.map(fn e -> :digraph.edge(map, e) end)
      |> Enum.find(fn
        {_, _, _, [^dir]} -> true
        _ -> false
      end)

    to
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
