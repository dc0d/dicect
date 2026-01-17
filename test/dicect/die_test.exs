defmodule Dicect.DieTest do
  use DicectUnitTest, async: true
  doctest Dicect.Die

  alias Dicect.Die

  describe "new" do
    @describe_fixtures %{
      input: 2,
      expected: %Die{sides: 2, outcomes: [1, 2]}
    }

    @describe_fixtures %{
      input: [-1, 0, 1],
      expected: %Die{sides: 3, outcomes: [-1, 0, 1]}
    }

    test "new", %{registered: %{describe_fixtures: describe_fixtures}} = _context do
      for fixture <- describe_fixtures do
        case fixture do
          %{input: input, expected: expected} ->
            assert Die.new(input) == expected
        end
      end
    end
  end

  describe "uplift" do
    @describe_fixtures %{
      input: 4,
      expected: 6
    }

    @describe_fixtures %{
      input: 6,
      expected: 8
    }

    @describe_fixtures %{
      input: 8,
      expected: 10
    }

    @describe_fixtures %{
      input: 10,
      expected: 12
    }

    @describe_fixtures %{
      input: 12,
      expected: 20
    }

    @describe_fixtures %{
      input: 20,
      expected: 20
    }

    @describe_fixtures %{
      input: Die.new(20),
      expected: Die.new(20)
    }

    @describe_fixtures %{
      input: Die.new(12),
      expected: Die.new(20)
    }

    @describe_fixtures %{
      input: Die.new(10),
      expected: Die.new(12)
    }

    @describe_fixtures %{
      input: Die.new(8),
      expected: Die.new(10)
    }

    @describe_fixtures %{
      input: Die.new(6),
      expected: Die.new(8)
    }

    @describe_fixtures %{
      input: Die.new(4),
      expected: Die.new(6)
    }

    test "uplift", %{registered: %{describe_fixtures: describe_fixtures}} = _context do
      for fixture <- describe_fixtures do
        case fixture do
          %{input: input, expected: expected} ->
            assert Die.uplift(input) == expected
        end
      end
    end
  end

  describe "degrade" do
    @describe_fixtures %{
      input: 20,
      expected: 12
    }

    @describe_fixtures %{
      input: 12,
      expected: 10
    }

    @describe_fixtures %{
      input: 10,
      expected: 8
    }

    @describe_fixtures %{
      input: 8,
      expected: 6
    }

    @describe_fixtures %{
      input: 6,
      expected: 4
    }

    @describe_fixtures %{
      input: 4,
      expected: 4
    }

    @describe_fixtures %{
      input: Die.new(20),
      expected: Die.new(12)
    }

    @describe_fixtures %{
      input: Die.new(12),
      expected: Die.new(10)
    }

    @describe_fixtures %{
      input: Die.new(10),
      expected: Die.new(8)
    }

    @describe_fixtures %{
      input: Die.new(8),
      expected: Die.new(6)
    }

    @describe_fixtures %{
      input: Die.new(6),
      expected: Die.new(4)
    }

    @describe_fixtures %{
      input: Die.new(4),
      expected: Die.new(4)
    }

    test "degrade", %{registered: %{describe_fixtures: describe_fixtures}} = _context do
      for fixture <- describe_fixtures do
        case fixture do
          %{input: input, expected: expected} ->
            assert Die.degrade(input) == expected
        end
      end
    end
  end
end
