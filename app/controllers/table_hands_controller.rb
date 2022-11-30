class TableHandsController < ApplicationController
  # STATUSES = %w[bet flop turn river end]
  before_action :set_poker_table, only: [:create]

  def create
    # .dup pour copier la constante sans la modifier
    @cards = TableHand::CARDS.dup
    @tablehand = TableHand.new
    @tablehand.poker_table = @poker_table
    @tablehand.current_call_amount = 2 * @tablehand.poker_table.small_blind
    tablehands = TableHand.where(poker_table: @poker_table)
    # Créer l'array de positions
    @tablehand.positions = @poker_table.players.active.map(&:position)
    @tablehand.first_player_position = tablehands.empty? ? @tablehand.positions[0] : @tablehand.positions[(@tablehand.positions.index(tablehands.last.first_player_position) + 1) % @tablehand.positions.count]
    @tablehand.current_player_position = @tablehand.positions[(@tablehand.positions.index(@tablehand.first_player_position) + 2) % @tablehand.positions.count]
    @tablehand.status = TableHand::STATUSES[0]
    @tablehand.save
    @poker_table.players.active.each do |player|
      player_hand = PlayerHand.new
      player_hand.player = player
      player_hand.player_card1 = pick_a_card
      player_hand.player_card2 = pick_a_card
      player_hand.table_hand = @tablehand
      player_hand.save
    end
    redirect_to poker_table_path(@poker_table)
  end

  private

  def set_poker_table
    @poker_table = PokerTable.find(params[:poker_table_id])
  end

  def pick_a_card
    @card = @cards.sample
    @cards.delete(@card)
  end
end
