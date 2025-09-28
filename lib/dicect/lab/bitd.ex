defmodule Dicect.Lab.BitD do
  @moduledoc false

  alias Dicect.Die
  alias Dicect.Probability

  def roll(opts \\ []) do
    default = [count: 1]
    opts = Keyword.merge(default, opts)
    count = opts[:count]

    dice = make_dice(count)
    predicates = make_predicates()

    result =
      Probability.calculate(dice, predicates)

    [:d_crit, :c_success, :b_mixed, :a_failure]
    |> Enum.zip(result)
    |> Enum.map(fn {x, y} -> %{r: x, p: y} end)
  end

  defp make_dice(count) do
    [{Die.new(6), count}]
  end

  defp make_predicates() do
    [
      fn rolled ->
        Enum.count(rolled, fn r -> r == 6 end) > 1
      end,
      fn rolled ->
        max = Enum.max(rolled)
        max == 6
      end,
      fn rolled ->
        max = Enum.max(rolled)
        max == 4 || max == 5
      end,
      fn rolled ->
        max = Enum.max(rolled)
        max < 4
      end
    ]
  end
end
