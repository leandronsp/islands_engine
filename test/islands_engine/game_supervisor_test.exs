defmodule IslandsEngine.GameSupervisorTest do
  use ExUnit.Case
  alias IslandsEngine.{Game, GameSupervisor}

  test "start and stop" do
    name = "Leandro"
    # ensure the shared table is empty
    :ets.delete(:game_state, name)

    # starts game
    {:ok, game} = GameSupervisor.start_game(name)

    via = Game.via_tuple(name)

    # assert the game is alive
    assert GenServer.whereis(via) == game
    assert Process.alive?(game)

    Game.add_player(game, "Renan")

    # check the current state
    [{_, value}] = :ets.lookup(:game_state, name)
    assert value.player_1.name == "Leandro"
    assert value.player_2.name == "Renan"

    GameSupervisor.stop_game(name)

    assert GenServer.whereis(via) == nil
    refute Process.alive?(game)
    assert :ets.lookup(:game_state, name) == []
  end

  # TODO: Implement it.
  # For some reason, supervisor is not restarting after crash.
  # In iex session it works.
  #
  #test "recover after crash" do
  #  name = "Other"
  #  :ets.delete(:game_state, name)

  #  {:ok, game} = GameSupervisor.start_game(name)

  #  via = Game.via_tuple(name)
  #  Game.add_player(game, "Yet another")

  #  # CRASH!
  #  Process.exit(game, :kaboom)

  #  # full recover
  #  state_data = :sys.get_state(via)
  #  assert state_data.player_1.name == "Other"
  #  assert state_data.player_2.name == "Yet another"
  #end
end
