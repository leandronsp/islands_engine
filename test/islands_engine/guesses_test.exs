defmodule IslandsEngine.GuessesTest do
  use ExUnit.Case
  doctest IslandsEngine.Guesses

  alias IslandsEngine.{Coordinate, Guesses}

  test "create a fresh guesses mapset" do
    guesses = Guesses.new()

    assert guesses.hits |> MapSet.size == 0
    assert guesses.misses |> MapSet.size == 0
  end

  test "adds a hit" do
    guesses = Guesses.new()
    {:ok, coordinate} = Coordinate.new(1, 8)
    guesses = Guesses.add(guesses, :hit, coordinate)

    coord = guesses.hits
    |> MapSet.to_list
    |> List.first

    assert coord.col == 8
    assert coord.row == 1

    assert guesses.misses |> MapSet.size == 0
  end

  test "adds a miss" do
    guesses = Guesses.new()
    {:ok, coordinate} = Coordinate.new(1, 8)
    guesses = Guesses.add(guesses, :miss, coordinate)

    coord = guesses.misses
    |> MapSet.to_list
    |> List.first

    assert coord.col == 8
    assert coord.row == 1

    assert guesses.hits |> MapSet.size == 0
  end
end
