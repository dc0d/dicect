defmodule Dicect.Lab.Breathless do
  @moduledoc false

  alias Dicect.Die
  alias Dicect.Probability

  def roll(sides, opts \\ []) do
    default = [position: :fair]
    opts = Keyword.merge(default, opts)
    position = opts[:position]

    dice = make_dice(sides, position)
    predicates = make_predicates(position)

    result =
      Probability.calculate(dice, predicates)

    [:c_success, :b_mixed, :a_failure]
    |> Enum.zip(result)
    |> Enum.map(fn {x, y} -> %{r: x, p: y} end)
  end

  defp make_dice(sides, :excellent) do
    [{Die.new(sides), 2}]
  end

  defp make_dice(sides, :good) do
    [{Die.new(sides + 1), 1}]
  end

  defp make_dice(sides, :fair) do
    [{Die.new(sides), 1}]
  end

  defp make_dice(sides, :bad) do
    [{Die.new(sides), 2}]
  end

  defp make_predicates(:excellent) do
    make_predicates(:fair)
  end

  defp make_predicates(:good) do
    make_predicates(:fair)
  end

  defp make_predicates(:fair) do
    [
      fn rolled ->
        Enum.any?(rolled, fn x -> x >= 5 end)
      end,
      fn rolled ->
        Enum.any?(rolled, fn x -> x >= 3 end) && Enum.all?(rolled, fn x -> x < 5 end)
      end,
      fn rolled ->
        Enum.all?(rolled, fn x -> x < 3 end)
      end
    ]
  end

  defp make_predicates(:bad) do
    [
      fn rolled ->
        rolled = [Enum.min(rolled)]
        Enum.any?(rolled, fn x -> x >= 5 end)
      end,
      fn rolled ->
        rolled = [Enum.min(rolled)]
        Enum.any?(rolled, fn x -> x >= 3 end) && Enum.all?(rolled, fn x -> x < 5 end)
      end,
      fn rolled ->
        rolled = [Enum.min(rolled)]
        Enum.all?(rolled, fn x -> x < 3 end)
      end
    ]
  end
end
