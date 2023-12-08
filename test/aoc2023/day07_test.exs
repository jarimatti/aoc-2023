defmodule Aoc2023.Day07Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day07

  def data() do
    """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """
  end

  test "part 1 sample data" do
    assert Day07.part1(data()) == 6440
  end

  test "part 1 real data" do
    assert Day07.part1(Day07.input()) > 251062340
  end
end
