class PlayerHandsController < ApplicationController
  before_action :set_current_things

  def call_hand
    call_amount = @table_hand.current_call_amount
    @player.stack -= call_amount
    @player.save
    @hand.bet_amount += call_amount
    @hand.save
    next_player
    redirect_to poker_table_path(@poker_table)
  end

  def raise_hand
  end

  def fold_hand
    @hand.folded = true
    @hand.save
    next_player
    redirect_to poker_table_path(@poker_table)
  end

  private

  def set_current_things
    @hand = current_user.player_hands.find(params[:id])
    @poker_table = @hand.table_hand.poker_table
    @player = @hand.player
    @table_hand = @hand.table_hand
  end

  def next_player
    positions = @table_hand.positions
    @table_hand.current_player_position = positions[(positions.index(@table_hand.current_player_position) + 1) % positions.count]
    # (@table_hand.current_player_position = @poker_table.players.active.count) if @table_hand.current_player_position == 0
    @table_hand.save
  end
end
