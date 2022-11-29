class TableHandsController < ApplicationController
  # STATUSES = %w[bet flop turn river end]
  before_action :set_poker_table, only: [:start]
  def start
    @cards = TableHand::CARDS
    @tablehand = TableHand.new
    @tablehand.poker_table = @poker_table
    @tablehand.current_call_amount = 2 * @tablehand.poker_table.small_blind
    @tablehand.first_player_position = 1
    @tablehand.status = TableHand::STATUSES[0]
    @poker_table.players.where(active: true).each do |player|
      player_hand = PlayerHand.new
      player_hand.player = player
      player_hand.player_card1 = pick_a_card
      player_hand.player_card2 = pick_a_card
      player_hand.table_hand = @tablehand
      player_hand.save
    end
  end


  private

  def set_poker_table
    @poker_table = params[:poker_table_id]
  end

  def pick_a_card
    @card = @cards.sample
    @cards.delete(@card)
  end
end


# t.integer "first_player_position"
# t.integer "current_player_position"
# t.string "status"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "current_call_amount
