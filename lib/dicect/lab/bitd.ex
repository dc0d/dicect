defmodule Dicect.Lab.BitD do
  @moduledoc false

  alias Dicect
  alias Dicect.Die
  alias Dicect.Probabilities

  alias VegaLite, as: Vl

  defdelegate colors, to: Dicect

  def run do
    create_lab()
    |> Map.put(:title, "BitD")
  end

  defp create_lab do
    for_count_1 =
      roll(count: 1)
      |> Enum.map(fn %{p: p, r: r} -> %{"count" => 1, "tier" => 1, "p_1" => p, "r_1" => r} end)

    for_count_2 =
      roll(count: 2)
      |> Enum.map(fn %{p: p, r: r} -> %{"count" => 2, "tier" => 2, "p_2" => p, "r_2" => r} end)

    for_count_3 =
      roll(count: 3)
      |> Enum.map(fn %{p: p, r: r} -> %{"count" => 3, "tier" => 3, "p_3" => p, "r_3" => r} end)

    for_count_4 =
      roll(count: 4)
      |> Enum.map(fn %{p: p, r: r} -> %{"count" => 4, "tier" => 4, "p_4" => p, "r_4" => r} end)

    for_count_5 =
      roll(count: 5)
      |> Enum.map(fn %{p: p, r: r} -> %{"count" => 5, "tier" => 5, "p_5" => p, "r_5" => r} end)

    diagrams =
      [for_count_1, for_count_2, for_count_3, for_count_4, for_count_5]
      |> Enum.with_index()
      |> Enum.flat_map(fn {_tier, index} ->
        tier_num = index + 1

        line_layer =
          Vl.new()
          |> Vl.transform(filter: "datum.tier == #{tier_num}")
          |> Vl.mark(:line, color: Enum.at(colors(), index), tooltip: true)
          |> Vl.encode_field(:x, "r_#{tier_num}", type: :ordinal, title: "Outcome")
          |> Vl.encode_field(:y, "p_#{tier_num}", type: :quantitative, title: "Probability")
          |> Vl.encode_field(:color, "count",
            type: :nominal,
            title: "Count",
            scale: [range: colors()]
          )

        text_layer =
          Vl.new()
          |> Vl.transform(filter: "datum.tier == #{tier_num}")
          |> Vl.transform(calculate: "datum.p_#{tier_num} * 100", as: "p_#{tier_num}_pct")
          |> Vl.mark(:text, dy: -10, fontSize: 10)
          |> Vl.encode_field(:x, "r_#{tier_num}", type: :ordinal)
          |> Vl.encode_field(:y, "p_#{tier_num}", type: :quantitative)
          |> Vl.encode_field(:text, "p_#{tier_num}_pct", type: :quantitative, format: ".2f")
          |> Vl.encode_field(:color, "count",
            type: :nominal,
            scale: [range: colors()]
          )

        [line_layer, text_layer]
      end)

    data = for_count_1 ++ for_count_2 ++ for_count_3 ++ for_count_4 ++ for_count_5

    %{data: data, diagrams: diagrams}
  end

  defp roll(count: count) do
    [0, 1, 2, 3]
    |> Enum.zip(
      Probabilities.calculate(
        create_dice(count: count),
        create_predicates()
      )
    )
    |> Enum.map(fn {r, p} -> %{r: r, p: p} end)
  end

  defp create_dice(count: count) do
    [{Die.new(6), count}]
  end

  defp create_predicates do
    [
      fn rolled ->
        max = Enum.max(rolled)
        max < 4
      end,
      fn rolled ->
        max = Enum.max(rolled)
        max == 4 || max == 5
      end,
      fn rolled ->
        max = Enum.max(rolled)
        max == 6
      end,
      fn rolled ->
        Enum.count(rolled, fn r -> r == 6 end) > 1
      end
    ]
  end
end
