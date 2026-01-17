defmodule Dicect.Lab.Ironsworn do
  @moduledoc false

  alias Dicect
  alias Dicect.Die
  alias Dicect.Probabilities

  alias VegaLite, as: Vl

  defdelegate colors, to: Dicect

  def run do
    create_lab()
    |> Map.put(:title, "Ironsworn")
  end

  defp create_lab do
    for_stat_0 =
      roll(stat: 0)
      |> Enum.map(fn %{p: p, r: r} -> %{"stat" => 0, "tier" => 0, "p_0" => p, "r_0" => r} end)

    for_stat_1 =
      roll(stat: 1)
      |> Enum.map(fn %{p: p, r: r} -> %{"stat" => 1, "tier" => 1, "p_1" => p, "r_1" => r} end)

    for_stat_2 =
      roll(stat: 2)
      |> Enum.map(fn %{p: p, r: r} -> %{"stat" => 2, "tier" => 2, "p_2" => p, "r_2" => r} end)

    for_stat_3 =
      roll(stat: 3)
      |> Enum.map(fn %{p: p, r: r} -> %{"stat" => 3, "tier" => 3, "p_3" => p, "r_3" => r} end)

    for_stat_4 =
      roll(stat: 4)
      |> Enum.map(fn %{p: p, r: r} -> %{"stat" => 4, "tier" => 4, "p_4" => p, "r_4" => r} end)

    diagrams =
      [for_stat_0, for_stat_1, for_stat_2, for_stat_3, for_stat_4]
      |> Enum.with_index()
      |> Enum.flat_map(fn {_tier, index} ->
        tier_num = index

        line_layer =
          Vl.new()
          |> Vl.transform(filter: "datum.tier == #{tier_num}")
          |> Vl.mark(:line, color: Enum.at(colors(), index), tooltip: true)
          |> Vl.encode_field(:x, "r_#{tier_num}", type: :ordinal, title: "Outcome")
          |> Vl.encode_field(:y, "p_#{tier_num}", type: :quantitative, title: "Probability")
          |> Vl.encode_field(:color, "stat",
            type: :nominal,
            title: "Stat",
            scale: [range: colors()]
          )

        text_layer =
          Vl.new()
          |> Vl.transform(filter: "datum.tier == #{tier_num}")
          |> Vl.transform(calculate: "datum.p_#{tier_num} * 100", as: "p_#{tier_num}_pct")
          |> Vl.mark(:text, dy: -10, fontSize: 10)
          |> Vl.encode_field(:x, "r_#{tier_num}", type: :ordinal)
          |> Vl.encode_field(:y, "p_#{tier_num}", type: :quantitative)
          |> Vl.encode_field(:text, "p_#{tier_num}_pct", type: :quantitative, format: ".1f")
          |> Vl.encode_field(:color, "stat",
            type: :nominal,
            scale: [range: colors()]
          )

        [line_layer, text_layer]
      end)

    data = for_stat_0 ++ for_stat_1 ++ for_stat_2 ++ for_stat_3 ++ for_stat_4

    %{data: data, diagrams: diagrams}
  end

  defp roll(stat: stat) do
    [0, 1, 2]
    |> Enum.zip(
      Probabilities.calculate(
        create_dice(),
        create_predicates(stat: stat)
      )
    )
    |> Enum.map(fn {r, p} -> %{r: r, p: p} end)
  end

  defp create_dice do
    [{Die.new(10), 2}, {Die.new(6), 1}]
  end

  defp create_predicates(stat: stat) do
    [
      fn [challenge1, challenge2, action] ->
        action = action + stat
        action <= challenge1 && action <= challenge2
      end,
      fn [challenge1, challenge2, action] ->
        action = action + stat

        (action > challenge1 && action <= challenge2) ||
          (action <= challenge1 && action > challenge2)
      end,
      fn [challenge1, challenge2, action] ->
        action = action + stat
        action > challenge1 && action > challenge2
      end
    ]
  end
end
