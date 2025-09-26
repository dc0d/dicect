defmodule Dicect.Lab.Scale do
  @moduledoc false

  def scale(data) do
    %{r: min} = data |> Enum.min_by(fn %{r: r} -> r end)
    %{r: max} = data |> Enum.max_by(fn %{r: r} -> r end)

    data
    |> Enum.map(fn %{p: p, r: r} ->
      %{
        p: p,
        r: scale_number(n: r, data_range: {min, max}, scaled_range: {1, 100})
      }
    end)
  end

  defp scale_number(n: n, data_range: {dmin, dmax}, scaled_range: {smin, smax}) do
    (n - dmin) * (smax - smin) / (dmax - dmin) + smin
  end
end
