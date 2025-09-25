defmodule Dicect.Probability do
  @moduledoc """
  Functions for calculating probabilities of die rolls.
  """

  alias Dicect.Combinations
  alias Dicect.Die

  @type die_count :: {Die.t(), non_neg_integer()}
  @type die_count_list :: [die_count()]
  @type combination :: [integer()]
  @type combinations :: [combination()]
  @type predicate :: (any() -> any())
  @type predicates :: [predicate, ...]

  @doc """
  Calculates the probabilities of given predicates over all possible combinations
  of outcomes from a list of dice and their counts.

  ## Examples

      iex> Dicect.Probability.calculate([{Dicect.Die.new(2), 2}], [fn [a, b] -> a + b == 2 end])
      [0.25]
  """
  @spec calculate([...], any()) :: list()
  def calculate([{%Die{}, _count} | _] = dice, predicates) do
    combinations = Combinations.produce_combinations(dice)
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
