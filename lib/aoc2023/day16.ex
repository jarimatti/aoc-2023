defmodule Aoc2023.Day16 do
  defmodule Tile do
    def new(item) do
      %{
        item: item,
        light_enters: %{
          north: false,
          south: false,
          east: false,
          west: false
        }
      }
    end

    def lit?(tile) do
      Enum.any?(tile.light_enters, fn {_, v} -> v end)
    end

    def enter_light_from(tile, from) do
      case tile.light_enters[from] do
        true ->
          :already_seen

        false ->
          new_tile = put_in(tile, [:light_enters, from], true)
          {new_tile, exit_directions(tile.item, from)}
      end
    end

    defp exit_directions(:empty, :north), do: [:south]
    defp exit_directions(:empty, :south), do: [:north]
    defp exit_directions(:empty, :east), do: [:west]
    defp exit_directions(:empty, :west), do: [:east]

    defp exit_directions({:mirror, :slant_right}, :north), do: [:west]
    defp exit_directions({:mirror, :slant_right}, :south), do: [:east]
    defp exit_directions({:mirror, :slant_right}, :east), do: [:south]
    defp exit_directions({:mirror, :slant_right}, :west), do: [:north]

    defp exit_directions({:mirror, :slant_left}, :north), do: [:east]
    defp exit_directions({:mirror, :slant_left}, :south), do: [:west]
    defp exit_directions({:mirror, :slant_left}, :east), do: [:north]
    defp exit_directions({:mirror, :slant_left}, :west), do: [:south]

    defp exit_directions({:splitter, :horizontal}, :north), do: [:east, :west]
    defp exit_directions({:splitter, :horizontal}, :south), do: [:east, :west]
    defp exit_directions({:splitter, :horizontal}, :east), do: [:west]
    defp exit_directions({:splitter, :horizontal}, :west), do: [:east]

    defp exit_directions({:splitter, :vertical}, :north), do: [:south]
    defp exit_directions({:splitter, :vertical}, :south), do: [:north]
    defp exit_directions({:splitter, :vertical}, :east), do: [:north, :south]
    defp exit_directions({:splitter, :vertical}, :west), do: [:north, :south]
  end

  def input() do
    File.read!("input/day16.txt")
  end

  def part1(data) do
    map = parse_data(data)

    light(map, {0, 0}, :west)
    |> Enum.count(fn {_, tile} -> Tile.lit?(tile) end)
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
