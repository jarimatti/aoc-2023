defmodule Aoc2023.Day15Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day15

  def data() do
    """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """
  end

  test "part 1 sample data" do
    assert Day15.part1(data()) == 1320
  end

  test "part 2 sample data" do
    assert Day15.part2(data()) == 145
  end
end
