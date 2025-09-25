defmodule Dicect.Combinations do
  @moduledoc """
  Functions for producing combinations of die outcomes.
  """

  alias Dicect.Die
  alias Dicect.Combinations.Support

  @type die_count :: {Die.t(), non_neg_integer()}
  @type die_count_list :: [die_count()]
  @type combination :: [integer()]
  @type combinations :: [combination()]

  @doc """
  Produces all possible combinations of outcomes from a list of dice and their counts.
  Each element in the input list is a tuple containing a `Dicect.Die` struct and a positive integer
  representing how many times that die is rolled.

  ## Examples

      iex> Dicect.Combinations.produce_combinations([{Dicect.Die.new(2), 1}, {Dicect.Die.new(2), 1}])
      [
        [1, 1],
        [1, 2],
        [2, 1],
        [2, 2]
      ]

      iex> Dicect.Combinations.produce_combinations([{Dicect.Die.new(3), 1}, {Dicect.Die.new(2), 1}])
      [
        [1, 1],
        [1, 2],
        [2, 1],
        [2, 2],
        [3, 1],
        [3, 2]
      ]

      iex> Dicect.Combinations.produce_combinations([{Dicect.Die.new(2), 1}, {Dicect.Die.new(10), 2}]) |> Enum.take(10)
      [
        [1, 1, 1],
        [1, 1, 2],
        [1, 1, 3],
        [1, 1, 4],
        [1, 1, 5],
        [1, 1, 6],
        [1, 1, 7],
        [1, 1, 8],
        [1, 1, 9],
        [1, 1, 10]
      ]
  """
  @spec produce_combinations(die_count_list()) :: combinations()
  def produce_combinations([{%Die{}, n} | _] = dice) when is_integer(n) and n > 0 do
    pick_outcomes(dice) |> Support.cross()
  end

  defp pick_outcomes([{%Die{outcomes: outcomes}, n}]) do
    outcomes |> List.duplicate(n)
  end

  defp pick_outcomes([{%Die{outcomes: outcomes}, n} | tail]) do
    List.duplicate(outcomes, n) ++ pick_outcomes(tail)
  end
end
