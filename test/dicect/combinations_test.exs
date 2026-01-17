defmodule Dicect.CombinationsTest do
  use DicectUnitTest, async: true
  doctest Dicect.Combinations

  alias Dicect.Combinations
  alias Dicect.Die

  describe "Combinations.combinations/1" do
    @describe_fixtures %{
      input: [{Die.new(2), 1}],
      expected_output: [[1], [2]]
    }

    @describe_fixtures %{
      input: [{Die.new(2), 2}],
      expected_output: [[1, 1], [1, 2], [2, 1], [2, 2]]
    }

    @describe_fixtures %{
      input: [{Die.new(2), 1}, {Die.new(2), 1}],
      expected_output: [[1, 1], [1, 2], [2, 1], [2, 2]]
    }

    @describe_fixtures %{
      input: [{Die.new(3), 1}, {Die.new(2), 2}],
      expected_output: [
        [1, 1, 1],
        [1, 1, 2],
        [1, 2, 1],
        [1, 2, 2],
        [2, 1, 1],
        [2, 1, 2],
        [2, 2, 1],
        [2, 2, 2],
        [3, 1, 1],
        [3, 1, 2],
        [3, 2, 1],
        [3, 2, 2]
      ]
    }

    @describe_fixtures %{
      input: [{Die.new(3), 1}, {Die.new(2), 1}, {Die.new(2), 1}],
      expected_output: [
        [1, 1, 1],
        [1, 1, 2],
        [1, 2, 1],
        [1, 2, 2],
        [2, 1, 1],
        [2, 1, 2],
        [2, 2, 1],
        [2, 2, 2],
        [3, 1, 1],
        [3, 1, 2],
        [3, 2, 1],
        [3, 2, 2]
      ]
    }

    @describe_fixtures %{
      input: [{Die.new(6), 1}, {Die.new(10), 2}],
      expected_output:
        Enum.flat_map(1..6, fn d6 ->
          Enum.flat_map(1..10, fn d10_1 ->
            Enum.map(1..10, fn d10_2 ->
              [d6, d10_1, d10_2]
            end)
          end)
        end)
    }

    test "combinations/1", %{registered: %{describe_fixtures: describe_fixtures}} = _context do
      for fixture <- describe_fixtures do
        case fixture do
          %{input: input, expected_output: expected_output} ->
            assert Combinations.combinations(input) == expected_output
        end
      end
    end
  end
end
