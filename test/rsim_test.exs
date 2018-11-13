defmodule RsimTest do
  use ExUnit.Case
  doctest Rsim

  test "greets the world" do
    assert Rsim.hello() == :world
  end
end
