defmodule Aoc2023.Day08 do
  def input() do
    File.read!("input/day08.txt")
  end

  def part1(data) do
    {instructions, map} = parse_data(data)

    run(instructions, map, "AAA", &reached_goal1/1)
  end

  def part2(data) do
    {instructions, map} = parse_data(data)

    vertices = Map.keys(map)
    start_vertices = Enum.filter(vertices, fn s -> String.ends_with?(s, "A") end)

    run(instructions, map, start_vertices, &reached_goal2/1)
  end

  defp run(instructions, map, start_vertex, reached_goal) do
    instructions
    |> Stream.cycle()
    |> Enum.reduce_while({0, start_vertex}, fn dir, {count, vertex} ->
      case reached_goal.(vertex) do
        true ->
          {:halt, count}

        false ->
          {:cont, {count + 1, step_vertex(map, vertex, dir)}}
      end
    end)
  end

  def reached_goal1("ZZZ"), do: true
  def reached_goal1(_), do: false

  def reached_goal2(vertex) do
    String.ends_with?(vertex, "Z")
  end

  defp step_vertex(map, vertex, dir) do
    {left, right} = Map.get(map, vertex)

    case dir do
      :left -> left
      :right -> right
    end
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
    map_strings
    |> Enum.map(&parse_map_line/1)
    |> Enum.reduce(%{}, fn {from, left, right}, map ->
      Map.put(map, from, {left, right})
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
