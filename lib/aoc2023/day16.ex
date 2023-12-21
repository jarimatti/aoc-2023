defmodule Aoc2023.Day16 do
  alias Aoc2023.Day16.Tile

  def input() do
    File.read!("input/day16.txt")
  end

  def part1(data) do
    map = parse_data(data)

    light(map, {0, 0}, :west)
    |> Enum.count(fn {_, tile} -> Tile.lit?(tile) end)
  end

  def part2(data) do
    # stub
    0
  end

  defp parse_data(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, x}, map ->
        tile =
          char
          |> parse_item()
          |> Tile.new()

        Map.put(map, {x, y}, tile)
      end)
    end)
  end

  defp parse_item("."), do: :empty
  defp parse_item("/"), do: {:mirror, :slant_right}
  defp parse_item("\\"), do: {:mirror, :slant_left}
  defp parse_item("-"), do: {:splitter, :horizontal}
  defp parse_item("|"), do: {:splitter, :vertical}

  def light(map, position, from) do
    tile = Map.get(map, position)
    {new_tile, new_entries} = step(tile, position, from)
    new_map = Map.put(map, position, new_tile)

    light(new_map, new_entries)
  end

  defp light(map, []) do
    map
  end

  defp light(map, [{position, from} | rest]) do
    case Map.get(map, position) do
      nil ->
        light(map, rest)

      tile ->
        {new_tile, new_entries} = step(tile, position, from)
        new_map = Map.put(map, position, new_tile)
        light(new_map, new_entries ++ rest)
    end
  end

  def next_position_with_entry({x, y}, :north), do: {{x, y - 1}, :south}
  def next_position_with_entry({x, y}, :south), do: {{x, y + 1}, :north}
  def next_position_with_entry({x, y}, :east), do: {{x + 1, y}, :west}
  def next_position_with_entry({x, y}, :west), do: {{x - 1, y}, :east}

  defp step(tile, position, from) do
    {t, exits} =
      case Tile.enter_light_from(tile, from) do
        :already_seen -> {tile, []}
        result -> result
      end

    new_entries = Enum.map(exits, fn exit_dir -> next_position_with_entry(position, exit_dir) end)
    {t, new_entries}
  end
end
