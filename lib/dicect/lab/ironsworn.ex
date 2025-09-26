defmodule Dicect.Lab.Ironsworn do
  @moduledoc false

  alias Dicect.Die
  alias Dicect.Probability

  def with_stat(stat) do
    result =
      Probability.calculate(
        [{Die.new(6), 1}, {Die.new(10), 2}],
        [
          fn [d6, d10_1, d10_2] ->
            d6 = d6 + stat
            d6 > d10_1 && d6 > d10_2
          end,
          fn [d6, d10_1, d10_2] ->
            d6 = d6 + stat
            (d6 > d10_1 && d6 <= d10_2) || (d6 <= d10_1 && d6 > d10_2)
          end,
          fn [d6, d10_1, d10_2] ->
            d6 = d6 + stat
            d6 <= d10_1 && d6 <= d10_2
          end
        ]
      )

    [:c_strong, :b_weak, :a_miss]
    |> Enum.zip(result)
    |> Enum.map(fn {x, y} -> %{r: x, p: y} end)
  end
end
