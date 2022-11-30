class PlayerHandsController < ApplicationController
  before_action :set_current_things

  def call_hand
    call_amount = @table_hand.current_call_amount
    @player.stack -= call_amount
    @player.save
    @hand.bet_amount += call_amount
    @hand.save
    next_player
  end

  def raise_hand
    raise_amount = params[:raise_amount].to_i
    @player.stack -= raise_amount
    @player.save
    @hand.bet_amount += raise_amount
    @hand.save
    @table_hand.current_call_amount += raise_amount
    @table_hand.counter = 0
    @table_hand.save
    next_player
  end

  def fold_hand
    @hand.folded = true
    @hand.save
    next_player
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
    index_of_next_player = (positions.index(@table_hand.current_player_position) + 1) % positions.count
    @table_hand.current_player_position = positions[index_of_next_player]
    @table_hand.counter += 1
    @table_hand.save
    if @poker_table.players.active.find_by(position: @table_hand.current_player_position).player_hands.last.folded == true
      next_player
    end
    if @table_hand.counter >= positions.count
      case @table_hand.status
      when 'bet' then redirect_to table_hand_flop_path(@table_hand)
      when 'flop' then redirect_to table_hand_turn_path(@table_hand)
      when 'turn' then redirect_to table_hand_river_path(@table_hand)
      # when 'river' then redirect_to table_hand_end_path(@table_hand)
      end
    else
      redirect_to poker_table_path(@poker_table)
    end
  end
end
