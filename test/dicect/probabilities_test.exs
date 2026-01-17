defmodule Dicect.ProbabilitiesTest do
  use DicectUnitTest, async: true
  doctest Dicect.Probabilities

  alias Dicect.Die
  alias Dicect.Probabilities

  test "Probabilities.calculate/1" do
    for fixture <- describe_fixtures() do
      case fixture do
        %{input: %{dice: dice, predicates: predicates}, expected_output: expected_output} ->
          Probabilities.calculate(dice, predicates)
          |> Enum.zip(expected_output)
          |> Enum.each(fn {p, e} ->
            assert_in_delta(p, e, 0.01)
          end)
      end
    end
  end

  defp describe_fixtures do
    [
      %{
        input: %{dice: [{Die.new(10), 1}], predicates: [fn [a] -> a >= 9 end]},
        expected_output: [20 / 100]
      },
      %{
        input: %{dice: [{Die.new(2), 2}], predicates: [fn [a, b] -> a + b == 2 end]},
        expected_output: [25 / 100]
      },
      %{
        input: %{
          dice: [{Die.new(6), 2}],
          predicates:
            for(resolution <- 2..12) do
              fn [a, b] -> a + b == resolution end
            end
        },
        expected_output: [
          2.78 / 100,
          5.56 / 100,
          8.33 / 100,
          11.11 / 100,
          13.89 / 100,
          16.67 / 100,
          13.89 / 100,
          11.11 / 100,
          8.33 / 100,
          5.56 / 100,
          2.78 / 100
        ]
      },
      %{
        input: %{
          dice: [{Die.new([-1, 0, 1]), 4}],
          predicates:
            for(resolution <- -4..4) do
              fn [a, b, c, d] -> a + b + c + d == resolution end
            end
        },
        expected_output: [
          1.23 / 100,
          4.94 / 100,
          12.35 / 100,
          19.75 / 100,
          23.46 / 100,
          19.75 / 100,
          12.35 / 100,
          4.94 / 100,
          1.23 / 100
        ]
      },
      %{
        input: %{
          dice: [{Die.new(6), 1}, {Die.new(10), 2}],
          predicates: [
            fn rolled -> ironsworn_predicate(rolled, 0, :miss) end,
            fn rolled -> ironsworn_predicate(rolled, 0, :weak_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 0, :strong_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 1, :miss) end,
            fn rolled -> ironsworn_predicate(rolled, 1, :weak_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 1, :strong_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 2, :miss) end,
            fn rolled -> ironsworn_predicate(rolled, 2, :weak_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 2, :strong_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 3, :miss) end,
            fn rolled -> ironsworn_predicate(rolled, 3, :weak_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 3, :strong_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 4, :miss) end,
            fn rolled -> ironsworn_predicate(rolled, 4, :weak_hit) end,
            fn rolled -> ironsworn_predicate(rolled, 4, :strong_hit) end
          ]
        },
        expected_output: [
          59.17 / 100,
          31.67 / 100,
          9.17 / 100,
          45.17 / 100,
          39.67 / 100,
          15.17 / 100,
          33.17 / 100,
          43.67 / 100,
          23.17 / 100,
          23.17 / 100,
          43.67 / 100,
          33.17 / 100,
          15.17 / 100,
          39.67 / 100,
          45.17 / 100
        ]
      }
    ]
  end

  defp ironsworn_predicate([d6, d10_1, d10_2], stat, :strong_hit) do
    d6 = d6 + stat
    d6 > d10_1 && d6 > d10_2
  end

  defp ironsworn_predicate([d6, d10_1, d10_2], stat, :weak_hit) do
    d6 = d6 + stat
    (d6 <= d10_1 && d6 > d10_2) || (d6 > d10_1 && d6 <= d10_2)
  end

  defp ironsworn_predicate([d6, d10_1, d10_2], stat, :miss) do
    d6 = d6 + stat
    d6 <= d10_1 && d6 <= d10_2
  end
end
