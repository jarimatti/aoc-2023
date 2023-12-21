defmodule Aoc2023.Day16Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day16

  def data() do
    """
    .|...\\....
    |.-.\\.....
    .....|-...
    ........|.
    ..........
    .........\\
    ..../.\\\\..
    .-.-/..|..
    .|....-|.\\
    ..//.|....
    """
  end

  test "part 1 sample data" do
    assert Day16.part1(data()) == 46
  end

  test "part 2 sample data" do
    assert Day16.part2(data()) == 51
  end
end
