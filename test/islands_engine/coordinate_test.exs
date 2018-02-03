defmodule IslandsEngine.CoordinateTest do
  use ExUnit.Case
  doctest IslandsEngine.Coordinate

  alias IslandsEngine.{Coordinate}

  test "creates coordinate" do
    {:ok, coordinate} = Coordinate.new(1, 1)

    assert coordinate.row == 1
    assert coordinate.col == 1
  end

  test "restrict coordinates to be 10x10 and throw error otherwise" do
    assert Coordinate.new(10, 11) == {:error, :invalid_coordinate}
  end
end
