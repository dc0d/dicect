defmodule Dicect.Combinations.Support do
  @moduledoc """
  Support functions for combinations.
  """

  @doc """
  Computes the Cartesian product of a list of lists.

  ## Examples

      iex> Dicect.Combinations.Support.cross([])
      []

      iex> Dicect.Combinations.Support.cross([[]])
      []

      iex> Dicect.Combinations.Support.cross([[1, 2], [3, 4]])
      [
        [1, 3],
        [1, 4],
        [2, 3],
        [2, 4]
      ]

      iex> Dicect.Combinations.Support.cross([[1, 2], [3, 4], [5, 6]])
      [
        [1, 3, 5],
        [1, 3, 6],
        [1, 4, 5],
        [1, 4, 6],
        [2, 3, 5],
        [2, 3, 6],
        [2, 4, 5],
        [2, 4, 6]
      ]

      iex> Dicect.Combinations.Support.cross([[1, 2]])
      [1, 2]

      iex> Dicect.Combinations.Support.cross([[1, 2], [3]])
      [
        [1, 3],
        [2, 3]
      ]
  """
  def cross([]), do: []
  def cross([hd]), do: hd

  def cross([hd | tail]) do
    for a <- hd,
        b <-
          Enum.map(cross(tail), fn
            b when is_list(b) -> [a | b]
            b -> [a, b]
          end) do
      b
    end
  end
end
