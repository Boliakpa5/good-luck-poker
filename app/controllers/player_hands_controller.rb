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
      prepare_cards
      case @table_hand.status
      when 'bet' then flop
      when 'flop' then turn
      when 'turn' then river
      # when 'river' then end
      end
    else
      redirect_to poker_table_path(@poker_table)
    end
  end

  def flop
    @table_hand.table_card1 = pick_a_card
    @table_hand.table_card2 = pick_a_card
    @table_hand.table_card3 = pick_a_card
    @table_hand.status = TableHand::STATUSES[1]
    @table_hand.counter = 0
    @table_hand.save
    redirect_to poker_table_path(@poker_table)
  end

  def turn
    @table_hand.table_card4 = pick_a_card
    @table_hand.status = TableHand::STATUSES[2]
    @table_hand.counter = 0
    @table_hand.save
    redirect_to poker_table_path(@poker_table)
  end

  def river
    @table_hand.table_card5 = pick_a_card
    @table_hand.status = TableHand::STATUSES[3]
    @table_hand.counter = 0
    @table_hand.save
    redirect_to poker_table_path(@poker_table)
  end

  def prepare_cards
    @cards = TableHand::CARDS.dup
    @table_hand.player_hands.each do |player_hand|
      @cards.delete(player_hand.player_card1)
      @cards.delete(player_hand.player_card2)
    end
    @cards.delete(@table_hand.table_card1)
    @cards.delete(@table_hand.table_card2)
    @cards.delete(@table_hand.table_card3)
    @cards.delete(@table_hand.table_card4)
  end
end
