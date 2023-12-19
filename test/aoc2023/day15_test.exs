defmodule Aoc2023.Day15Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day15

  test "part 1 sample data" do
    data =
      """
      rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
      """

    assert Day15.part1(data) == 1320
  end
end
