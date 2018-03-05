defmodule IslandsEngine.GameTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.{Game, Rules, Coordinate}

  setup do
    {:ok, game} = Game.start_link("Frank")
    {:ok, game: game}
  end

  test "adding player", %{game: game} do
    Game.add_player(game, "Fompz")
    state_data = :sys.get_state(game)
    assert state_data.player_2.name == "Fompz"
  end

  test "position island", %{game: game} do
    Game.add_player(game, "Vilma")
    state_data = :sys.get_state(game)
    assert state_data.rules.state == :players_set

    Game.position_island(game, :player_1, :square, 1, 1)
    state_data = :sys.get_state(game)
    board = state_data.player_1.board

    coordinates = board.square.coordinates |> MapSet.to_list

    assert coordinates == [
      %Coordinate{col: 1, row: 1},
      %Coordinate{col: 1, row: 2},
      %Coordinate{col: 2, row: 1},
      %Coordinate{col: 2, row: 2}
    ]
  end

  test "position invalid island", %{game: game} do
    Game.add_player(game, "Vilma")

    assert {:error, :invalid_coordinate} == Game.position_island(game, :player_1, :dot, 12, 1)
    assert {:error, :invalid_island_type} == Game.position_island(game, :player_1, :wrong, 1, 1)
  end

  test "position rules not met", %{game: game} do
    Game.add_player(game, "Vilma")

    :sys.replace_state(game, fn state_data ->
      %{state_data | rules: %Rules{state: :player_1_turn}}
    end)

    assert :error == Game.position_island(game, :player_1, :square, 1, 1)
  end

  test "set islands", %{game: game} do
    Game.add_player(game, "Dino")

    Game.position_island(game, :player_1, :atoll, 1, 1)
    Game.position_island(game, :player_1, :dot, 1, 4)
    Game.position_island(game, :player_1, :l_shape, 1, 5)
    Game.position_island(game, :player_1, :s_shape, 5, 1)
    Game.position_island(game, :player_1, :square, 5, 5)

    Game.set_islands(game, :player_1)

    state_data = :sys.get_state(game)
    assert state_data.rules.state == :players_set
    assert state_data.rules.player_1 == :islands_set
  end

  test "guess coordinate", %{game: game} do
    Game.add_player(game, "Dino")

    Game.position_island(game, :player_1, :dot, 1, 1)
    Game.position_island(game, :player_2, :square, 1, 1)

    state_data = :sys.get_state(game)

    :sys.replace_state(game, fn _data ->
      %{state_data | rules: %Rules{state: :player_1_turn}}
    end)

    assert {:miss, :none, :no_win} == Game.guess_coordinate(game, :player_1, 5, 5)
    assert :error == Game.guess_coordinate(game, :player_1, 5, 5)

    assert {:hit, :dot, :win} == Game.guess_coordinate(game, :player_2, 1, 1)
  end

  test "start GenServer using via_tuple" do
    via = Game.via_tuple("Lena")
    Game.start_link("Lena")

    state_data = :sys.get_state(via)
    assert state_data.rules.state == :initialized
    {:error, {:already_started, _pid}} = Game.start_link("Lena")
  end
end
