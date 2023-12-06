defmodule Aoc2023.Day06Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day06

  def data() do
    """
    Time:      7  15   30
    Distance:  9  40  200
    """
  end

  test "part 1 sample" do
    assert Day06.part1(data()) == 4 * 8 * 9
  end
end
