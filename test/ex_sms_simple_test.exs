defmodule ExSmsSimpleTest do
  use ExUnit.Case
  doctest ExSmsSimple

  test "greets the world" do
    assert ExSmsSimple.hello() == :world
  end
end
