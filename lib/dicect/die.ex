defmodule Dicect.Die do
  @moduledoc """
  A module representing a die with a specified number of sides and possible outcomes.
  """

  @type t :: %__MODULE__{
          sides: pos_integer(),
          outcomes: list(integer())
        }

  defstruct sides: 2, outcomes: []

  def new([_, _ | _] = outcomes) do
    unique_outcomes = Enum.uniq(outcomes)

    %__MODULE__{
      sides: length(unique_outcomes),
      outcomes: unique_outcomes
    }
  end

  def new(sides) when is_integer(sides) and sides >= 2 do
    outcomes = Enum.to_list(1..sides)

    %__MODULE__{
      sides: sides,
      outcomes: outcomes
    }
  end

  # degrade and uplift functions for polyhedral dice

  @doc """
  Degrades a polyhedral die to the next lower standard die.
  """
  def degrade(polyhedral_dice)

  def degrade(%__MODULE__{sides: 20}), do: new(12)
  def degrade(%__MODULE__{sides: 12}), do: new(10)
  def degrade(%__MODULE__{sides: 10}), do: new(8)
  def degrade(%__MODULE__{sides: 8}), do: new(6)
  def degrade(%__MODULE__{sides: 6}), do: new(4)
  def degrade(%__MODULE__{sides: 4}), do: new(4)

  def degrade(20), do: 12
  def degrade(12), do: 10
  def degrade(10), do: 8
  def degrade(8), do: 6
  def degrade(6), do: 4
  def degrade(4), do: 4

  @doc """
  Uplifts a polyhedral die to the next higher standard die.
  """
  def uplift(polyhedral_dice)

  def uplift(%__MODULE__{sides: 20}), do: new(20)
  def uplift(%__MODULE__{sides: 12}), do: new(20)
  def uplift(%__MODULE__{sides: 10}), do: new(12)
  def uplift(%__MODULE__{sides: 8}), do: new(10)
  def uplift(%__MODULE__{sides: 6}), do: new(8)
  def uplift(%__MODULE__{sides: 4}), do: new(6)

  def uplift(4), do: 6
  def uplift(6), do: 8
  def uplift(8), do: 10
  def uplift(10), do: 12
  def uplift(12), do: 20
  def uplift(20), do: 20
end
