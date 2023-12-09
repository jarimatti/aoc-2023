defmodule Aoc2023.Day08Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day08

  test "part 1 sample data 1" do
    data =
      """
      RL
      
      AAA = (BBB, CCC)
      BBB = (DDD, EEE)
      CCC = (ZZZ, GGG)
      DDD = (DDD, DDD)
      EEE = (EEE, EEE)
      GGG = (GGG, GGG)
      ZZZ = (ZZZ, ZZZ)
      """

    assert Day08.part1(data) == 2
  end

  test "part 1 sample data 2" do
    data =
      """
      LLR
      
      AAA = (BBB, BBB)
      BBB = (AAA, ZZZ)
      ZZZ = (ZZZ, ZZZ)
      """

    assert Day08.part1(data) == 6
  end

  test "part 2 sample data" do
    data =
      """
      LR
      
      11A = (11B, XXX)
      11B = (XXX, 11Z)
      11Z = (11B, XXX)
      22A = (22B, XXX)
      22B = (22C, 22C)
      22C = (22Z, 22Z)
      22Z = (22B, 22B)
      XXX = (XXX, XXX)
      """

    assert Day08.part2(data) == 6
  end
end
