defmodule IslandsEngine.BoardTest do
  use ExUnit.Case
  doctest IslandsEngine.Board

  alias IslandsEngine.{Board, Coordinate, Island}

  test "playing" do
    board = Board.new()
    {:ok, square_coordinate} = Coordinate.new(1, 1)
    {:ok, square} = Island.new(:square, square_coordinate)

    board = Board.position_island(board, :square, square)

    {:ok, dot_coordinate} = Coordinate.new(2, 2)
    {:ok, dot} = Island.new(:dot, dot_coordinate)

    assert Board.position_island(board, :dot, dot) == {:error, :overlapping_island}

    {:ok, dot_coordinate} = Coordinate.new(3, 3)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    board = Board.position_island(board, :dot, dot)

    {:ok, miss} = Coordinate.new(10, 10)
    {:miss, :none, :no_win, board} = Board.guess(board, miss)

    {:ok, hit} = Coordinate.new(1, 1)
    {:hit, :none, :no_win, board} = Board.guess(board, hit)

    square = %{square | hit_coordinates: square.coordinates}
    board = Board.position_island(board, :square, square)

    {:ok, winner_hit} = Coordinate.new(3, 3)
    {:hit, :dot, :win, _} = Board.guess(board, winner_hit)
  end
end
