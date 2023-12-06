defmodule Aoc2023.Day06 do
  def input() do
    File.read!("input/day06.txt")
  end

  def part1(data) do
    max_times_and_distances = parse_races(data)

    max_times_and_distances
    |> Enum.map(&count_ways_to_win/1)
    |> Enum.product()
  end

  def part2(_data) do
    # stub
    0
  end

  defp parse_races(data) do
    [time_line, distance_line | _] = String.split(data, "\n")

    times = parse_times(time_line)
    distances = parse_distances(distance_line)

    Enum.zip(times, distances)
  end

  defp parse_times("Time:" <> rest), do: parse_line(rest)

  defp parse_distances("Distance:" <> rest), do: parse_line(rest)

  defp parse_line(rest) do
    rest
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp count_ways_to_win({t_max, s_max}) do
    [t0, t1] =
      solve_quadratic(-1, t_max, -s_max)
      |> limit_times(t_max, s_max)

    t1 - t0 + 1
  end

  defp solve_quadratic(a, b, c) do
    sqrt = :math.sqrt(b ** 2 - 4 * a * c)

    x0 = (-b + sqrt) / (2 * a)
    x1 = (-b - sqrt) / (2 * a)

    Enum.sort([x0, x1])
  end

  defp limit_times([t0, t1], t_max, s_max) do
    t0 = max(round(:math.ceil(t0)), 1)
    t1 = min(round(:math.floor(t1)), t_max - 1)

    narrow_if_at_edges([t0, t1], t_max, s_max)
  end

  defp narrow_if_at_edges([t0, t1], t_max, s_max) do
    t0 =
      case is_solution?(t0, t_max, s_max) do
        true -> t0 + 1
        _ -> t0
      end

    t1 =
      case is_solution?(t1, t_max, s_max) do
        true -> t1 - 1
        _ -> t1
      end

    [t0, t1]
  end

  defp is_solution?(t, t_max, s_max) do
    -(t ** 2) + t_max * t == s_max
  end
end
