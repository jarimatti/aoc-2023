defmodule Aoc2023.Day01Test do
  use ExUnit.Case, async: true

  test "part 1 sample works" do
    data = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    assert Aoc2023.Day01.part1(data) == 142
  end

  test "part 1 another sample works" do
    data = """
    1abc3
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    assert Aoc2023.Day01.part1(data) == 143
  end

  test "part 2 sample data" do
    data = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

    assert Aoc2023.Day01.part2(data) == 281
  end
end
