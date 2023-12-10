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

  test "part 2 with data 1" do
    data =
      """
      ...........
      .S-------7.
      .|F-----7|.
      .||.....||.
      .||.....||.
      .|L-7.F-J|.
      .|..|.|..|.
      .L--J.L--J.
      ...........
      """

    assert Day10.part2(data) == 4
  end

  test "part 2 with data 2" do
    data =
      """
      ..........
      .S------7.
      .|F----7|.
      .||....||.
      .||....||.
      .|L-7F-J|.
      .|..||..|.
      .L--JL--J.
      ..........
      """

    assert Day10.part2(data) == 4
  end

  test "part 2 with larger example" do
    data =
      """
      .F----7F7F7F7F-7....
      .|F--7||||||||FJ....
      .||.FJ||||||||L7....
      FJL7L7LJLJ||LJ.L-7..
      L--J.L7...LJS7F-7L7.
      ....F-J..F7FJ|L7L7L7
      ....L7.F7||L7|.L7L7|
      .....|FJLJ|FJ|F7|.LJ
      ....FJL-7.||.||||...
      ....L---J.LJ.LJLJ...
      """

    assert Day10.part2(data) == 8
  end

  test "part 2 counts junk pipes inside" do
    data =
      """
      FF7FSF7F7F7F7F7F---7
      L|LJ||||||||||||F--J
      FL-7LJLJ||||||LJL-77
      F--JF--7||LJLJ7F7FJ-
      L---JF-JLJ.||-FJLJJ7
      |F|F-JF---7F7-L7L|7|
      |FFJF7L7F-JF7|JL---7
      7-L-JL7||F7|L7F-7F7|
      L.L7LFJ|||||FJL7||LJ
      L7JLJL-JLJLJL--JLJ.L
      """

    assert Day10.part2(data) == 10
  end
end
