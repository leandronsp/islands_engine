defmodule IslandsEngine.IslandTest do
  use ExUnit.Case
  doctest IslandsEngine.Island

  alias IslandsEngine.{Coordinate, Island}

  test "creates a dot island" do
    {:ok, start} = Coordinate.new(1, 1)
    {:ok, island} = Island.new(:dot, start)
    coordinates = island.coordinates |> MapSet.to_list

    assert coordinates == [
      %Coordinate{col: 1, row: 1}
    ]
  end

  test "creates a square island" do
    {:ok, start} = Coordinate.new(1, 1)
    {:ok, island} = Island.new(:square, start)
    coordinates = island.coordinates |> MapSet.to_list

    assert coordinates == [
      %Coordinate{col: 1, row: 1},
      %Coordinate{col: 1, row: 2},
      %Coordinate{col: 2, row: 1},
      %Coordinate{col: 2, row: 2}
    ]
  end

  test "creates a atoll island" do
    {:ok, start} = Coordinate.new(1, 1)
    {:ok, island} = Island.new(:atoll, start)
    coordinates = island.coordinates |> MapSet.to_list

    assert coordinates == [
      %Coordinate{col: 1, row: 1},
      %Coordinate{col: 1, row: 3},
      %Coordinate{col: 2, row: 1},
      %Coordinate{col: 2, row: 2},
      %Coordinate{col: 2, row: 3}
    ]
  end

  test "creates a l_shape island" do
    {:ok, start} = Coordinate.new(1, 1)
    {:ok, island} = Island.new(:l_shape, start)
    coordinates = island.coordinates |> MapSet.to_list

    assert coordinates == [
      %Coordinate{col: 1, row: 1},
      %Coordinate{col: 1, row: 2},
      %Coordinate{col: 1, row: 3},
      %Coordinate{col: 2, row: 3}
    ]
  end

  test "creates a s_shape island" do
    {:ok, start} = Coordinate.new(1, 1)
    {:ok, island} = Island.new(:s_shape, start)
    coordinates = island.coordinates |> MapSet.to_list

    assert coordinates == [
      %Coordinate{col: 1, row: 2},
      %Coordinate{col: 2, row: 1},
      %Coordinate{col: 2, row: 2},
      %Coordinate{col: 3, row: 1}
    ]
  end

  test "validates invalid coordinate" do
    assert {:error, :invalid_coordinate} == Island.new(:dot, %Coordinate{row: 1, col: 11})
  end

  test "validates invalid island type" do
    {:ok, start} = Coordinate.new(1, 1)
    assert {:error, :invalid_island_type} == Island.new(:yeah, start)
  end

  test "checks overlaps" do
    {:ok, square_coordinate} = Coordinate.new(1, 1)
    {:ok, square} = Island.new(:square, square_coordinate)

    {:ok, dot_coordinate} = Coordinate.new(1, 2)
    {:ok, dot} = Island.new(:dot, dot_coordinate)

    {:ok, l_shape_coordinate} = Coordinate.new(5, 5)
    {:ok, l_shape} = Island.new(:l_shape, l_shape_coordinate)

    assert Island.overlaps?(square, dot)
    refute Island.overlaps?(square, l_shape)
    refute Island.overlaps?(dot, l_shape)
  end

  test "guess a hit" do
    {:ok, dot_coordinate} = Coordinate.new(4, 4)
    {:ok, dot} = Island.new(:dot, dot_coordinate)

    {:ok, guess} = Coordinate.new(4, 4)
    {:hit, dot} = Island.guess(dot, guess)

    hits = dot.hit_coordinates |> MapSet.to_list

    assert hits == [
      %Coordinate{col: 4, row: 4}
    ]

    assert Island.forested?(dot)
  end

  test "guess a miss" do
    {:ok, dot_coordinate} = Coordinate.new(4, 4)
    {:ok, dot} = Island.new(:dot, dot_coordinate)

    {:ok, guess} = Coordinate.new(4, 3)
    assert Island.guess(dot, guess) == :miss

    assert dot.hit_coordinates |> MapSet.size == 0
    refute Island.forested?(dot)
  end

end
