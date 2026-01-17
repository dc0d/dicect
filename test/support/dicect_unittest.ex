defmodule DicectUnitTest do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      ExUnit.Case.register_describe_attribute(__MODULE__, :describe_fixtures, accumulate: true)
    end
  end
end
