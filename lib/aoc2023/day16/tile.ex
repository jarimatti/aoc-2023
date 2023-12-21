defmodule Aoc2023.Day16.Tile do

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
