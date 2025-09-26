defmodule Dicect.ProbabilityTest do
  use ExUnit.Case
  doctest Dicect.Probability
  alias Dicect.Die
  alias Dicect.Probability

  defp describe_fixtures do
    [
      %{
        input: %{dice: [{Die.new(10), 1}], predicates: [fn [a] -> a >= 9 end]},
        expected: [20]
      },
      %{
        input: %{dice: [{Die.new(2), 2}], predicates: [fn [a, b] -> a + b == 2 end]},
        expected: [25]
      },
      %{
        input: %{
          dice: [{Die.new(6), 2}],
          predicates:
            for(resolution <- 2..12) do
              fn [a, b] -> a + b == resolution end
            end
        },
        expected: [2.78, 5.56, 8.33, 11.11, 13.89, 16.67, 13.89, 11.11, 8.33, 5.56, 2.78]
      },
      %{
        input: %{
          dice: [{Die.new([{-1, 1 / 3}, {0, 1 / 3}, {1, 1 / 3}]), 4}],
          predicates:
            for(resolution <- -4..4) do
              fn [a, b, c, d] -> a + b + c + d == resolution end
            end
        },
        expected: [1.23, 4.94, 12.35, 19.75, 23.46, 19.75, 12.35, 4.94, 1.23]
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
        expected: [
          59.17,
          31.67,
          9.17,
          45.17,
          39.67,
          15.17,
          33.17,
          43.67,
          23.17,
          23.17,
          43.67,
          33.17,
          15.17,
          39.67,
          45.17
        ]
      }
    ]
  end

  describe "Dicect.Probability.calculate/2" do
    test "calculate/2" do
      for %{
            input: %{dice: dice, predicates: predicates},
            expected: expected
          } <-
            describe_fixtures() do
        transformed_actual =
          Probability.calculate(dice, predicates)
          |> Enum.map(fn x -> Float.round(100 * x, 2) end)

        assert transformed_actual == expected
      end
    end
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
