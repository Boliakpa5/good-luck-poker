class TableHandsController < ApplicationController
  # STATUSES = %w[bet flop turn river end]
  before_action :set_poker_table, only: [:create, :flop, :turn, :river]
  before_action :set_table_hand, only: [:flop, :turn, :river]

  def create
    # .dup pour copier la constante sans la modifier
    @cards = TableHand::CARDS.dup
    @players = @poker_table.players.active
    @tablehand = TableHand.new
    @tablehand.poker_table = @poker_table
    @tablehand.current_call_amount = 2 * @tablehand.poker_table.small_blind
    # Créer l'array de positions
    @tablehand.positions = @players.map(&:position).sort
    @tablehand.first_player_position = @poker_table.table_hands.empty? ? @tablehand.positions[0] : @tablehand.positions[(@tablehand.positions.index(@poker_table.table_hands.last.first_player_position) + 1) % @tablehand.positions.count]
    @tablehand.current_player_position = @tablehand.positions[(@tablehand.positions.index(@tablehand.first_player_position) + 2) % @tablehand.positions.count]
    @tablehand.status = TableHand::STATUSES[0]
    @tablehand.save
    @players.each do |player|
      player_hand = PlayerHand.new
      player_hand.player = player
      player_hand.player_card1 = pick_a_card
      player_hand.player_card2 = pick_a_card
      player_hand.table_hand = @tablehand
      player_hand.save
    end
    redirect_to poker_table_path(@poker_table)
  end

  def flop
    @poker_table.table_card1 = pick_a_card
    @poker_table.table_card2 = pick_a_card
    @poker_table.table_card3 = pick_a_card
    @tablehand.status = TableHand::STATUSES[1]
    @poker_table.save
    redirect_to poker_table_path(@poker_table)
  end

  def turn
    @poker_table.table_card4 = pick_a_card
    @tablehand.status = TableHand::STATUSES[2]
    @poker_table.save
    redirect_to poker_table_path(@poker_table)
  end

  def river
    @poker_table.table_card5 = pick_a_card
    @tablehand.status = TableHand::STATUSES[3]
    @poker_table.save
    redirect_to poker_table_path(@poker_table)
  end

  private

  def set_poker_table
    @poker_table = PokerTable.find(params[:poker_table_id])
  end

  def set_table_hand
    @tablehand = current_user.players.last.poker_table.table_hand.last
  end

  def pick_a_card
    @card = @cards.sample
    @cards.delete(@card)
  end
end
