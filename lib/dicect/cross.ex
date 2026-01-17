defmodule Dicect.Cross do
  @moduledoc false

  @spec cross([list()]) :: list()
  def cross([]), do: []
  def cross([h]), do: h

  def cross([h | t]) do
    for vh <- h, vt <- cross(t), do: ([vh] ++ [vt]) |> List.flatten()
  end
end
