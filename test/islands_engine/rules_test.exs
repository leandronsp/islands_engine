defmodule IslandsEngine.RulesTest do
  use ExUnit.Case
  doctest IslandsEngine.Rules

  alias IslandsEngine.{Rules}

  test "transition from initialized to players_set when add_player action is triggered" do
    rules = Rules.new()
    assert rules.state == :initialized

    {:ok, rules} = Rules.check(rules, :add_player)
    assert rules.state == :players_set
  end

  test "only allows add_player action for initialized state" do
    rules = Rules.new()
    assert :error == Rules.check(rules, :wrong_action)
    assert rules.state == :initialized
  end

  test "players positioning" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:position_islands, :player_1})
    {:ok, rules} = Rules.check(rules, {:position_islands, :player_2})

    assert rules.state == :players_set
  end

  test "both players have islands set" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}

    # position and set islands for player_1
    {:ok, rules} = Rules.check(rules, {:position_islands, :player_1})
    {:ok, rules} = Rules.check(rules, {:set_islands, :player_1})

    # player_1 cannot position once hes already set islands
    assert Rules.check(rules, {:position_islands, :player_1}) == :error

    # states not changed because player_2 hasnt set islands yet
    assert rules.state == :players_set

    # position and set islands for player_2
    {:ok, rules} = Rules.check(rules, {:position_islands, :player_2})
    {:ok, rules} = Rules.check(rules, {:set_islands, :player_2})

    # player_2 cannot position once hes already set islands
    assert Rules.check(rules, {:position_islands, :player_2}) == :error

    # now its time for player_1 to turn
    assert rules.state == :player_1_turn
  end

  test "players cannot position neither set islands once game waits to turn" do
    rules = Rules.new()
    rules = %{rules | state: :player_1_turn}
    rules = %{rules | player_1: :islands_set}
    rules = %{rules | player_2: :islands_set}

    assert Rules.check(rules, :add_player) == :error

    assert Rules.check(rules, {:position_islands, :player_1}) == :error
    assert Rules.check(rules, {:position_islands, :player_2}) == :error

    assert Rules.check(rules, {:set_islands, :player_1}) == :error
    assert Rules.check(rules, {:set_islands, :player_2}) == :error
  end

end
