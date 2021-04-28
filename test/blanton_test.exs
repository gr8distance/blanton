defmodule BlantonTest do
  use ExUnit.Case

  test "version" do
    assert Blanton.version() == "0.1.5"
  end
end
