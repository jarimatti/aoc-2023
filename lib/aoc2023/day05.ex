defmodule Aoc2023.Day05 do
  def input() do
    File.read!("input/day05.txt")
  end

  def part1(data) do
    seeds_and_mappings = parse_data(data)

    seeds_and_mappings[:seeds]
    |> Enum.map(fn s -> seed_to_location(s, seeds_and_mappings) end)
    |> Enum.map(fn {:location, x} -> x end)
    |> Enum.min()
  end

  def part2(data) do
    seeds_and_mappings = parse_data(data)

    seeds_and_mappings[:seeds]
    |> Enum.map(fn s -> seed_to_location(s, seeds_and_mappings) end)
    |> Enum.map(fn {:location, x} -> x end)
    |> Enum.min()
  end

  def parse_data(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_by(&empty_string?/1)
    |> Enum.reject(fn x -> x == [""] end)
    |> Enum.reduce(%{}, &parse_section/2)
  end

  defp empty_string?(""), do: true
  defp empty_string?(_), do: false

  defp parse_section(["seeds: " <> line], acc) do
    seeds =
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(fn i -> {:seed, i} end)

    Map.put(acc, :seeds, seeds)
  end

  defp parse_section(["seed-to-soil map:" | rest], acc) do
    do_parse_section(rest, :seed, :soil, acc)
  end

  defp parse_section(["soil-to-fertilizer map:" | rest], acc) do
    do_parse_section(rest, :soil, :fertilizer, acc)
  end

  defp parse_section(["fertilizer-to-water map:" | rest], acc) do
    do_parse_section(rest, :fertilizer, :water, acc)
  end

  defp parse_section(["water-to-light map:" | rest], acc) do
    do_parse_section(rest, :water, :light, acc)
  end

  defp parse_section(["light-to-temperature map:" | rest], acc) do
    do_parse_section(rest, :light, :temperature, acc)
  end

  defp parse_section(["temperature-to-humidity map:" | rest], acc) do
    do_parse_section(rest, :temperature, :humidity, acc)
  end

  defp parse_section(["humidity-to-location map:" | rest], acc) do
    do_parse_section(rest, :humidity, :location, acc)
  end

  defp do_parse_section(lines, source_category, destination_category, acc) do
    mappings = parse_ranges(lines, source_category, destination_category)
    Map.put(acc, {source_category, destination_category}, mappings)
  end

  defp parse_ranges(lines, source_category, destination_category) do
    lines
    |> Enum.map(fn l -> parse_range(l, source_category, destination_category) end)
    |> Enum.sort()
  end

  defp parse_range(line, source_category, destination_category) do
    [d, s, len] =
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    {{source_category, s..(s + len)}, {destination_category, d}}
  end

  def map_category({source_category, x}, dest_category, all_mappings) do
    mappings = all_mappings[{source_category, dest_category}]

    mapping = Enum.find(mappings, fn {{^source_category, r}, _} -> x in r end)

    value =
      case mapping do
        nil -> x
        {{^source_category, start.._}, {^dest_category, soil}} -> x - start + soil
      end

    {dest_category, value}
  end

  defp seed_to_location({:seed, _} = s, mappings) do
    soil = map_category(s, :soil, mappings)
    fertilizer = map_category(soil, :fertilizer, mappings)
    water = map_category(fertilizer, :water, mappings)
    light = map_category(water, :light, mappings)
    temperature = map_category(light, :temperature, mappings)
    humidity = map_category(temperature, :humidity, mappings)
    map_category(humidity, :location, mappings)
  end
end
