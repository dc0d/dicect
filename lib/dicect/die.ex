defmodule Dicect.Die do
  @moduledoc """
  A struct representing a die with a specified number of sides.
  """

  @type t :: %__MODULE__{
          sides: non_neg_integer(),
          outcomes: list(integer()),
          probabilities: %{key: integer(), value: float()}
        }

  defstruct sides: 0, outcomes: [], probabilities: %{}

  @doc """
  Creates a new `Dicect.Die` struct.
  Can be called in three ways:
  1. With a positive integer `n`, creating a fair die with sides numbered from `1` to `n`.
  2. With a list of integers, creating a fair die with the specified outcomes.
  3. With a list of `{outcome, probability}` tuples, creating a biased die.
     - The probabilities must sum to `1.0`.
  Raises `ArgumentError` if the input is invalid.

  ## Examples

      iex> Dicect.Die.new(6)
      %Dicect.Die{
        sides: 6,
        outcomes: [1, 2, 3, 4, 5, 6],
        probabilities: %{1 => 1/6, 2 => 1/6, 3 => 1/6, 4 => 1/6, 5 => 1/6, 6 => 1/6}
      }

      iex> Dicect.Die.new([1, 2, 3])
      %Dicect.Die{
        sides: 3,
        outcomes: [1, 2, 3],
        probabilities: %{1 => 1/3, 2 => 1/3, 3 => 1/3}
      }

      iex> Dicect.Die.new([{1, 0.5}, {2, 0.5}])
      %Dicect.Die{
        sides: 2,
        outcomes: [1, 2],
        probabilities: %{1 => 0.5, 2 => 0.5}
      }

      iex> Dicect.Die.new([{1, 0.5}, {2, 0.4}])
      ** (ArgumentError) Total probability must sum to 1.0
  """
  @spec new(maybe_improper_list() | pos_integer()) :: Dicect.Die.t()
  def new([{o, p} | rest] = outcomes_probabilities)
      when is_list(rest) and is_integer(o) and is_float(p) and p >= 0 do
    outcomes = [o | Enum.map(rest, fn {outcome, _} -> outcome end)]

    total_probability =
      Enum.reduce(outcomes_probabilities, 0.0, fn {_, prob}, acc -> acc + prob end)

    delta = abs(total_probability - 1.0)

    if delta > 0.00001 do
      raise ArgumentError, "Total probability must sum to 1.0"
    end

    sides = length(outcomes)
    probabilities = Map.new(outcomes_probabilities)

    %__MODULE__{
      sides: sides,
      outcomes: outcomes,
      probabilities: probabilities
    }
  end

  def new(outcomes) when is_list(outcomes) and length(outcomes) > 0 do
    unique_outcomes = Enum.uniq(outcomes)
    sides = length(unique_outcomes)
    probability = 1.0 / sides
    probabilities = Map.new(unique_outcomes, fn outcome -> {outcome, probability} end)

    %__MODULE__{
      sides: sides,
      outcomes: unique_outcomes,
      probabilities: probabilities
    }
  end

  def new(sides) when is_integer(sides) and sides > 0 do
    outcomes = Enum.to_list(1..sides)
    probability = 1.0 / sides
    probabilities = Map.new(outcomes, fn outcome -> {outcome, probability} end)

    %__MODULE__{
      sides: sides,
      outcomes: outcomes,
      probabilities: probabilities
    }
  end
end
