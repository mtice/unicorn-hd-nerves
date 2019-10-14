defmodule TimerTestTest do
  use ExUnit.Case
  doctest TimerTest

  test "greets the world" do
    assert TimerTest.hello() == :world
  end
end
