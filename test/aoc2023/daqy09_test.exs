defmodule Aoc2023.Day09Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day09

  test "part 1 with sample data" do
    data =
      """
      0 3 6 9 12 15
      1 3 6 10 15 21
      10 13 16 21 30 45
      """

    assert Day09.part1(data) == 18 + 28 + 68
  end
end
