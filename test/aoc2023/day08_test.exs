defmodule Aoc2023.Day08Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day08

  def data1() do
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
  end

  def data2() do
    """
    LLR
    
    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """
  end

  test "part 1 sample data 1" do
    assert Day08.part1(data1()) == 2
  end

  test "part 1 sample data 2" do
    assert Day08.part1(data2()) == 6
  end
end
