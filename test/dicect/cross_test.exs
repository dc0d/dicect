defmodule Dicect.CrossTest do
  use DicectUnitTest, async: true
  doctest Dicect.Cross

  alias Dicect.Cross

  describe "cross/1" do
    @describe_fixtures %{
      input: [],
      expected: []
    }

    @describe_fixtures %{
      input: [[]],
      expected: []
    }

    @describe_fixtures %{
      input: [[1, 2]],
      expected: [1, 2]
    }

    @describe_fixtures %{
      input: [[1], [2]],
      expected: [
        [1, 2]
      ]
    }

    @describe_fixtures %{
      input: [[1], [2, 3]],
      expected: [
        [1, 2],
        [1, 3]
      ]
    }

    @describe_fixtures %{
      input: [[1, 2], [3]],
      expected: [
        [1, 3],
        [2, 3]
      ]
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
      input: [[1, 2, 3], [4, 5], [6]],
      expected: [
        [1, 4, 6],
        [1, 5, 6],
        [2, 4, 6],
        [2, 5, 6],
        [3, 4, 6],
        [3, 5, 6]
      ]
    }

    test "cross/1", %{registered: %{describe_fixtures: describe_fixtures}} = _context do
      for fixture <- describe_fixtures do
        case fixture do
          %{input: input, expected: expected} ->
            assert Cross.cross(input) == expected
        end
      end
    end
  end
end
