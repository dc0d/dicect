defmodule Dicect.Lab.Fate do
  @moduledoc false

  alias Dicect.Die
  alias Dicect.Probability

  alias Dicect.Die
  alias Dicect.Probability

  def roll(opts \\ []) do
    default = [skill: 0, count: 4]
    opts = Keyword.merge(default, opts)
    skill = opts[:skill]
    count = opts[:count]

    dice = make_dice(count: count)
    predicates = make_predicates(skill: skill)

    result =
      Probability.calculate(dice, predicates)

    [
      :m_legendary,
      :l_epic,
      :k_fantastic,
      :j_superb,
      :i_great,
      :h_good,
      :g_fair,
      :f_average,
      :e_mediocre,
      :d_poor,
      :c_terrible,
      :b_catastrophic,
      :a_orrifying
    ]
    |> Enum.zip(result)
    |> Enum.map(fn {x, y} -> %{r: x, p: y} end)
  end

  defp make_dice(count: count) do
    [{Die.new([-1, 0, 1]), count}]
  end

  defp make_predicates(skill: skill) do
    [
      fn rolled ->
        Enum.sum(rolled) + skill >= 8
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == 7
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == 6
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == 5
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == 4
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == 3
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == 2
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == 1
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == 0
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == -1
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == -2
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == -3
      end,
      fn rolled ->
        Enum.sum(rolled) + skill == -4
      end
    ]
  end
end
