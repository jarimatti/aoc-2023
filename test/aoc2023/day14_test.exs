defmodule Aoc2023.Day14Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day14

  test "part 1 sample data" do
    data =
      """
      O....#....
      O.OO#....#
      .....##...
      OO.#O....O
      .O.....O#.
      O.#..O.#.#
      ..O..#O..O
      .......O..
      #....###..
      #OO..#....
      """

    assert Day14.part1(data) == 136
  end
end
