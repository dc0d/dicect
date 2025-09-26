defmodule Dicect.CombinationsTest do
  use ExUnit.Case
  doctest Dicect.Combinations
  alias Dicect.Combinations
  alias Dicect.Die

  ExUnit.Case.register_describe_attribute(__MODULE__, :describe_fixtures, accumulate: true)

  describe "Dicect.Combinations.produce_combinations/1" do
    @describe_fixtures %{
      input: [{Die.new(3), 1}],
      expected_conds: %{
        length: 3,
        at: [
          %{index: 0, combination: [1]},
          %{index: 1, combination: [2]},
          %{index: 2, combination: [3]}
        ]
      }
    }
    @describe_fixtures %{
      input: [{Die.new(2), 1}, {Die.new(2), 1}],
      expected_conds: %{
        length: 4,
        at: [
          %{index: 0, combination: [1, 1]},
          %{index: 1, combination: [1, 2]},
          %{index: 2, combination: [2, 1]},
          %{index: 3, combination: [2, 2]}
        ]
      }
    }
    @describe_fixtures %{
      input: [{Die.new(2), 2}],
      expected_conds: %{
        length: 4,
        at: [
          %{index: 0, combination: [1, 1]},
          %{index: 1, combination: [1, 2]},
          %{index: 2, combination: [2, 1]},
          %{index: 3, combination: [2, 2]}
        ]
      }
    }
    @describe_fixtures %{
      input: [{Die.new(3), 1}, {Die.new(2), 1}],
      expected_conds: %{
        length: 6,
        at: [
          %{index: 0, combination: [1, 1]},
          %{index: 1, combination: [1, 2]},
          %{index: 2, combination: [2, 1]},
          %{index: 3, combination: [2, 2]},
          %{index: 4, combination: [3, 1]},
          %{index: 5, combination: [3, 2]}
        ]
      }
    }
    @describe_fixtures %{
      input: [{Die.new(6), 1}, {Die.new(10), 2}],
      expected_conds: %{
        length: 600,
        at: [
          %{index: 0, combination: [1, 1, 1]},
          %{index: 9, combination: [1, 1, 10]},
          %{index: 90, combination: [1, 10, 1]},
          %{index: 100, combination: [2, 1, 1]},
          %{index: 599, combination: [6, 10, 10]}
        ]
      }
    }

    test "produce_combinations/1" do
      for %{input: input, expected_conds: expected_conds} <- @describe_fixtures do
        combinations = Combinations.produce_combinations(input)

        assert length(combinations) == abs(expected_conds.length)

        for %{index: index, combination: combination} <- expected_conds.at do
          assert Enum.at(combinations, index) == combination
        end
      end
    end
  end
end
