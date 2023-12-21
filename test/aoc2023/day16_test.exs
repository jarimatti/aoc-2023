defmodule Aoc2023.Day16Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day16

  test "part 1 sample data" do
    data =
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

    assert Day16.part1(data) == 46
  end
end
