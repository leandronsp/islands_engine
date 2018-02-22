defmodule IslandsEngine.Rules do
  alias __MODULE__

  defstruct state: :initialized,
            player_1: :islands_not_set,
            player_2: :islands_not_set

  def new(), do: %Rules{}

  def check(%Rules{state: :player_1_turn} = rules, {:win_check, win_or_not}) do
    case win_or_not do
      :no_win -> {:ok, rules}
      :win -> {:ok, %Rules{rules | state: :game_over}}
    end
  end

  def check(%Rules{state: :player_2_turn} = rules, {:win_check, win_or_not}) do
    case win_or_not do
      :no_win -> {:ok, rules}
      :win -> {:ok, %Rules{rules | state: :game_over}}
    end
  end

  def check(%Rules{state: :player_1_turn} = rules, {:guess_coordinate, :player_1}) do
    {:ok, %Rules{rules | state: :player_2_turn}}
  end

  def check(%Rules{state: :player_2_turn} = rules, {:guess_coordinate, :player_2}) do
    {:ok, %Rules{rules | state: :player_1_turn}}
  end

  def check(%Rules{state: :players_set} = rules, {:set_islands, player}) do
    rules = Map.put(rules, player, :islands_set)

    case both_players_islands_set?(rules) do
      true -> {:ok, %Rules{rules | state: :player_1_turn}}
      false -> {:ok, rules}
    end
  end

  def check(%Rules{state: :players_set} = rules, {:position_islands, player}) do
    case Map.fetch!(rules, player) do
      :islands_set -> :error
      :islands_not_set -> {:ok, rules}
    end
  end

  def check(%Rules{state: :initialized} = rules, :add_player) do
    {:ok, %Rules{rules | state: :players_set}}
  end

  def check(_state, _action), do: :error

  defp both_players_islands_set?(rules) do
    rules.player_1 == :islands_set && rules.player_2 == :islands_set
  end
end
