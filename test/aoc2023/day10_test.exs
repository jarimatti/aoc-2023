defmodule Aoc2023.Day10Test do
  use ExUnit.Case, async: true

  alias Aoc2023.Day10

  test "part 1 simple sample input" do
    data =
      """
      .....
      .S-7.
      .|.|.
      .L-J.
      .....
      """

    assert Day10.part1(data) == 4
  end

  test "part 1 simle sample with extra pipes" do
    data =
      """
      -L|F7
      7S-7|
      L|7||
      -L-J|
      L|-JF
      """

    assert Day10.part1(data) == 4
  end

  test "part 1 complex sample input" do
    data =
      """
      ..F7.
      .FJ|.
      SJ.L7
      |F--J
      LJ...
      """

    assert Day10.part1(data) == 8
  end

  test "part 1 complex sample with extra pipes" do
    data =
      """
      7-F7-
      .FJ|7
      SJLL7
      |F--J
      LJ.LJ
      """

    assert Day10.part1(data) == 8
  end
end
