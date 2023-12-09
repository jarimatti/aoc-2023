defmodule Aoc2023.Day02 do
  def input() do
    File.read!("input/day02.txt")
  end

  def part1(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&Aoc2023.empty_string?/1)
    |> Enum.map(&parse_game/1)
    |> Enum.filter(fn game -> is_game_possible(game, part1_bag()) end)
    |> Enum.map(fn {{:id, id}, _} -> id end)
    |> Enum.sum()
  end

  def part2(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&Aoc2023.empty_string?/1)
    |> Enum.map(&parse_game/1)
    |> Enum.map(&minimum_bag/1)
    |> Enum.map(&power/1)
    |> Enum.sum()
  end

  defp part1_bag() do
    %{
      red: 12,
      green: 13,
      blue: 14
    }
  end

  defp is_game_possible({_, moves}, bag) do
    Enum.all?(moves, fn move -> is_move_possible(move, bag) end)
  end

  defp is_move_possible(move, bag) do
    Map.get(move, :red, 0) <= bag.red and
      Map.get(move, :green, 0) <= bag.green and
      Map.get(move, :blue, 0) <= bag.blue
  end

  defp parse_game(line) do
    [id_part, moves_part] = String.split(line, ":")
    game_id = parse_id(id_part)

    moves =
      moves_part
      |> String.split(";")
      |> Enum.map(&parse_move/1)

    {game_id, moves}
  end

  defp parse_id("Game " <> id) do
    {:id, String.to_integer(id)}
  end

  defp parse_move(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_cube_count/1)
    |> Map.new()
  end

  defp parse_cube_count(string) do
    [number_string, colour_string] = String.split(string)

    count = String.to_integer(number_string)

    colour =
      case colour_string do
        "blue" -> :blue
        "red" -> :red
        "green" -> :green
      end

    {colour, count}
  end

  defp minimum_bag({_, moves}) do
    %{
      red: minimum_colour(moves, :red),
      green: minimum_colour(moves, :green),
      blue: minimum_colour(moves, :blue)
    }
  end

  defp minimum_colour(moves, colour) do
    moves
    |> Enum.map(fn bag -> Map.get(bag, colour, 0) end)
    |> Enum.max()
  end

  defp power(bag) do
    bag
    |> Map.values()
    |> Enum.product()
  end
end
