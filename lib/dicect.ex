defmodule Dicect do
  @moduledoc """
  LIBRARY
  """

  @spec even?(number()) :: boolean()
  @doc """
  Returns `true` if `n` is even, otherwise returns `false`.

  ## Examples

      iex> Dicect.even?(2)
      true

      iex> Dicect.even?(3)
      false
  """
  def even?(n) when is_number(n), do: Bitwise.band(as_int(n), 1) == 0

  @spec odd?(number()) :: boolean()
  @doc """
  Returns `true` if `n` is odd, otherwise returns `false`.

  ## Examples

      iex> Dicect.odd?(2)
      false

      iex> Dicect.odd?(3)
      true
  """
  def odd?(n) when is_number(n), do: Bitwise.band(as_int(n), 1) == 1

  defp as_int(n), do: trunc(n)
end
