defmodule Dicect.DieTest do
  use ExUnit.Case
  doctest Dicect.Die

  ExUnit.Case.register_describe_attribute(__MODULE__, :describe_fixtures, accumulate: true)

  describe "Dicect.Die.new/1" do
    @describe_fixtures %{
      input: 2,
      expected: %Dicect.Die{sides: 2, outcomes: [1, 2], probabilities: %{1 => 0.5, 2 => 0.5}}
    }
    @describe_fixtures %{
      input: [-1, 1],
      expected: %Dicect.Die{sides: 2, outcomes: [-1, 1], probabilities: %{-1 => 0.5, 1 => 0.5}}
    }
    @describe_fixtures %{
      input: [{-1, 1 / 3}, {0, 1 / 3}, {1, 1 / 3}],
      expected: %Dicect.Die{
        sides: 3,
        outcomes: [-1, 0, 1],
        probabilities: %{-1 => 1 / 3, 0 => 1 / 3, 1 => 1 / 3}
      }
    }
    @describe_fixtures %{
      input: [{-1, 0.1}, {0, 0.1}, {1, 0.1}],
      expected: "Total probability must sum to 1.0"
    }

    test "new/1" do
      for %{input: input, expected: expected} <- @describe_fixtures do
        try do
          assert Dicect.Die.new(input) == expected
        rescue
          e in ArgumentError -> assert e.message == expected
        end
      end
    end
  end
end
