defmodule Dicect.Combinations do
  @moduledoc """
  Functions for producing combinations of die outcomes.
  """

  alias Dicect.Cross
  alias Dicect.Die

  @spec combinations([{Die.t(), pos_integer()}]) :: [[integer()]]
  def combinations([{%Die{}, _n} | _] = dice) do
    all_outcomes(dice)
    |> Cross.cross()
    |> Enum.map(fn
      outcomes when is_list(outcomes) -> outcomes
      outcome -> [outcome]
    end)
  end

  defp all_outcomes([{%Die{outcomes: outcomes}, n}]) do
    List.duplicate(outcomes, n)
  end

  defp all_outcomes([{%Die{outcomes: outcomes}, n} | tail]) do
    List.duplicate(outcomes, n) ++ all_outcomes(tail)
  end
end
