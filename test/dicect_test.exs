defmodule DicectTest do
  use ExUnit.Case
  doctest Dicect

  ExUnit.Case.register_describe_attribute(__MODULE__, :describe_fixtures, accumulate: true)

  describe "Dicect.even?/1" do
    @describe_fixtures %{input: 2, expected: true}
    @describe_fixtures %{input: 1024, expected: true}
    @describe_fixtures %{input: 1, expected: false}
    @describe_fixtures %{input: 3, expected: false}
    @describe_fixtures %{input: 2.9, expected: true}

    test "even?" do
      for %{input: input, expected: expected} <- @describe_fixtures do
        assert Dicect.even?(input) == expected
      end
    end
  end

  describe "Dicect.odd?/1" do
    @describe_fixtures %{input: 2, expected: false}
    @describe_fixtures %{input: 1024, expected: false}
    @describe_fixtures %{input: 1, expected: true}
    @describe_fixtures %{input: 3, expected: true}
    @describe_fixtures %{input: 2.9, expected: false}

    test "odd?" do
      for %{input: input, expected: expected} <- @describe_fixtures do
        assert Dicect.odd?(input) == expected
      end
    end
  end
end
