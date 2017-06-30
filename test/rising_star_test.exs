defmodule RisingStarTest do
  use ExUnit.Case
  doctest RisingStar
  import RisingStar

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "hello" do
    assert hello == :world
  end
end
