defmodule Dicect.Combinations.SupportTest do
  use ExUnit.Case
  doctest Dicect.Die
  alias Dicect.Combinations.Support

  ExUnit.Case.register_describe_attribute(__MODULE__, :describe_fixtures, accumulate: true)

  describe "Dicect.Combinations.Support.cross/1" do
    @describe_fixtures %{
      input: [],
      expected: []
    }
    @describe_fixtures %{
      input: [[]],
      expected: []
    }
    @describe_fixtures %{
      input: [[1, 2], [3, 4]],
      expected: [
        [1, 3],
        [1, 4],
        [2, 3],
        [2, 4]
      ]
    }
    @describe_fixtures %{
      input: [[1, 2], [3, 4], [5, 6]],
      expected: [
        [1, 3, 5],
        [1, 3, 6],
        [1, 4, 5],
        [1, 4, 6],
        [2, 3, 5],
        [2, 3, 6],
        [2, 4, 5],
        [2, 4, 6]
      ]
    }
    @describe_fixtures %{
      input: [[1, 2]],
      expected: [1, 2]
    }
    @describe_fixtures %{
      input: [[1, 2], [3]],
      expected: [
        [1, 3],
        [2, 3]
      ]
    }

    test "cross/1" do
      for %{input: input, expected: expected} <- @describe_fixtures do
        assert Support.cross(input) == expected
      end
    end
  end
end
