defmodule Aoc2023 do
  def empty_string?(""), do: true
  def empty_string?(s) when is_binary(s), do: false
end
