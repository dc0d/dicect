defmodule Dicect.Lab.Fate do
  @moduledoc false

  alias Dicect
  alias Dicect.Die
  alias Dicect.Probabilities

  alias VegaLite, as: Vl

  defdelegate colors, to: Dicect

  def run(opts \\ []) do
    count = Keyword.get(opts, :count, 4)

    create_lab(count: count)
    |> Map.put(:title, "FATE")
  end

  defp create_lab(count: count) do
    for_skill_0 =
      roll(skill: 0, count: count)
      |> Enum.map(fn %{p: p, r: r} -> %{"skill" => 0, "tier" => 0, "p_0" => p, "r_0" => r} end)

    for_skill_1 =
      roll(skill: 1, count: count)
      |> Enum.map(fn %{p: p, r: r} -> %{"skill" => 1, "tier" => 1, "p_1" => p, "r_1" => r} end)

    for_skill_2 =
      roll(skill: 2, count: count)
      |> Enum.map(fn %{p: p, r: r} -> %{"skill" => 2, "tier" => 2, "p_2" => p, "r_2" => r} end)

    for_skill_3 =
      roll(skill: 3, count: count)
      |> Enum.map(fn %{p: p, r: r} -> %{"skill" => 3, "tier" => 3, "p_3" => p, "r_3" => r} end)

    for_skill_4 =
      roll(skill: 4, count: count)
      |> Enum.map(fn %{p: p, r: r} -> %{"skill" => 4, "tier" => 4, "p_4" => p, "r_4" => r} end)

    diagrams =
      [for_skill_0, for_skill_1, for_skill_2, for_skill_3, for_skill_4]
      |> Enum.with_index()
      |> Enum.flat_map(fn {_tier, index} ->
        tier_num = index

        line_layer =
          Vl.new()
          |> Vl.transform(filter: "datum.tier == #{tier_num}")
          |> Vl.mark(:line, color: Enum.at(colors(), index), tooltip: true)
          |> Vl.encode_field(:x, "r_#{tier_num}", type: :ordinal, title: "Outcome")
          |> Vl.encode_field(:y, "p_#{tier_num}", type: :quantitative, title: "Probability")
          |> Vl.encode_field(:color, "skill",
            type: :nominal,
            title: "Skill",
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
          |> Vl.encode_field(:color, "skill",
            type: :nominal,
            scale: [range: colors()]
          )

        [line_layer, text_layer]
      end)

    data = for_skill_0 ++ for_skill_1 ++ for_skill_2 ++ for_skill_3 ++ for_skill_4

    %{data: data, diagrams: diagrams}
  end

  defp roll(skill: skill, count: count) do
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    |> Enum.zip(
      Probabilities.calculate(
        create_dice(count: count),
        create_predicates(skill: skill)
      )
    )
    |> Enum.map(fn {r, p} -> %{r: r, p: p} end)
  end

  defp create_dice(count: count) do
    [{Die.new([-1, 0, 1]), count}]
  end

  defp create_predicates(skill: skill) do
    [
      fn rolled -> Enum.sum(rolled) + skill <= -4 end,
      fn rolled -> Enum.sum(rolled) + skill == -3 end,
      fn rolled -> Enum.sum(rolled) + skill == -2 end,
      fn rolled -> Enum.sum(rolled) + skill == -1 end,
      fn rolled -> Enum.sum(rolled) + skill == 0 end,
      fn rolled -> Enum.sum(rolled) + skill == 1 end,
      fn rolled -> Enum.sum(rolled) + skill == 2 end,
      fn rolled -> Enum.sum(rolled) + skill == 3 end,
      fn rolled -> Enum.sum(rolled) + skill == 4 end,
      fn rolled -> Enum.sum(rolled) + skill == 5 end,
      fn rolled -> Enum.sum(rolled) + skill == 6 end,
      fn rolled -> Enum.sum(rolled) + skill == 7 end,
      fn rolled -> Enum.sum(rolled) + skill >= 8 end
    ]
  end

  # def with(opts \\ []) do
  #   default = [skill: 0, count: 4]
  #   opts = Keyword.merge(default, opts)
  #   skill = opts[:skill]
  #   count = opts[:count]

  #   dice = make_dice(count: count)
  #   predicates = make_predicates(skill: skill)

  #   result =
  #     Probability.calculate(dice, predicates)

  #   [
  #     :m_legendary,
  #     :l_epic,
  #     :k_fantastic,
  #     :j_superb,
  #     :i_great,
  #     :h_good,
  #     :g_fair,
  #     :f_average,
  #     :e_mediocre,
  #     :d_poor,
  #     :c_terrible,
  #     :b_catastrophic,
  #     :a_orrifying
  #   ]
  #   |> Enum.zip(result)
  #   |> Enum.map(fn {x, y} -> %{r: x, p: y} end)
  # end

  # defp make_dice(count: count) do
  #   [{Die.new([-1, 0, 1]), count}]
  # end

  # defp make_predicates(skill: skill) do
  #   [
  #     fn rolled ->
  #       Enum.sum(rolled) + skill >= 8
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == 7
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == 6
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == 5
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == 4
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == 3
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == 2
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == 1
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == 0
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == -1
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == -2
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == -3
  #     end,
  #     fn rolled ->
  #       Enum.sum(rolled) + skill == -4
  #     end
  #   ]
  # end
end
