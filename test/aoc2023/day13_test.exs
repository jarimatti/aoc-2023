defmodule Aoc2023.Day13Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day13

  test "part 1 sample data" do
    data =
      """
      #.##..##.
      ..#.##.#.
      ##......#
      ##......#
      ..#.##.#.
      ..##..##.
      #.#.##.#.

      #...##..#
      #....#..#
      ..##..###
      #####.##.
      #####.##.
      ..##..###
      #....#..#
      """

    assert Day13.part1(data) == 405
  end
end
