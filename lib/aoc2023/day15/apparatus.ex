defmodule Aoc2023.Day15.Apparatus do
  @opaque t :: %{}

  @type box_id :: 0..255
  @type label :: String.t()
  @type focal_length :: non_neg_integer()
  @type operation :: {:remove, label()} | {:upsert, label(), focal_length()}

  defmodule Box do
    def new() do
      []
    end

    def remove(box, label) do
      List.keydelete(box, label, 0)
    end

    def upsert(box, label, focal_length) do
      List.keystore(box, label, 0, {label, focal_length})
    end

    def format(box) do
      Enum.map(box, fn {l, f} ->
        "[#{l} #{f}]"
      end)
    end

    def focusing_power(box) do
      box
      |> Enum.with_index(1)
      |> Enum.map(fn {{_, f}, i} -> f * i end)
      |> Enum.sum()
    end
  end

  @spec new() :: t()
  def new() do
    boxes =
      for x <- 0..255 do
        {x, Box.new()}
      end

    Map.new(boxes)
  end

  @spec apply(t(), box_id(), operation()) :: t()
  def apply(apparatus, box_id, {:remove, label}) do
    Map.update!(apparatus, box_id, fn box ->
      Box.remove(box, label)
    end)
  end

  def apply(apparatus, box_id, {:upsert, label, focal_length}) do
    Map.update!(apparatus, box_id, fn box ->
      Box.upsert(box, label, focal_length)
    end)
  end

  def format(apparatus) do
    apparatus
    |> Map.reject(fn
      {_, []} -> true
      {_, _} -> false
    end)
    |> Enum.sort_by(fn {k, _} -> k end)
    |> Enum.map(fn {k, v} ->
      ["Box #{k}: ", Box.format(v), "\n"]
    end)
  end

  def focusing_power(app) do
    app
    |> Enum.map(fn {box_id, box} ->
      (box_id + 1) * Box.focusing_power(box)
    end)
    |> Enum.sum()
  end
end
