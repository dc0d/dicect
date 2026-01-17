defmodule Dicect.Probabilities do
  @moduledoc false

  alias Dicect.Combinations
  alias Dicect.Die

  def calculate([{%Die{}, _count} | _] = dice, predicates) do
    combinations = Combinations.combinations(dice)
    calculate(combinations, predicates)
  end

  def calculate([c | _] = combinations, predicates) when is_list(c) do
    total = length(combinations)

    Enum.map(predicates, fn predicate ->
      successful = filter(combinations, predicate)
      successful / total
    end)
  end

  defp filter(combinations, predicate) do
    Enum.reduce(combinations, 0, fn combination, acc ->
      if predicate.(combination), do: acc + 1, else: acc
    end)
  end
end
