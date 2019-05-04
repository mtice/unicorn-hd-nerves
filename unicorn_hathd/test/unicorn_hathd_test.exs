defmodule UnicornHathdTest do
  use ExUnit.Case
  doctest UnicornHathd

  test "greets the world" do
    assert UnicornHathd.hello() == :world
  end
end
