defmodule Aoc2023.Day11Test do
  use ExUnit.Case, async: false

  alias Aoc2023.Day11

  def data() do
    """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """
  end

  test "part 1 sample data" do
    assert Day11.part1(data()) == 374
  end

  test "solve sample data with different factors" do
    assert Day11.solve(data(), 2) == 374
    assert Day11.solve(data(), 10) == 1030
    assert Day11.solve(data(), 100) == 8410
  end
end
