class TableHandsController < ApplicationController
  # STATUSES = %w[preflop flop turn river end]
  before_action :set_poker_table, only: [:create, :flop, :turn, :river]
  before_action :set_table_hand, only: [:flop, :turn, :river]

  def create
    # .dup pour copier la constante sans la modifier
    @cards = TableHand::CARDS.dup
    @players = @poker_table.players.active
    @players.each do |player|
      if player.stack <= (@poker_table.small_blind * 2)
        player.active = false
        player.save
        current_user.balance += @player.stack
        current_user.save
      end
    end
    @players = @poker_table.players.active
    @table_hand = TableHand.new
    @table_hand.poker_table = @poker_table
    @table_hand.current_call_amount = 2 * @table_hand.poker_table.small_blind
    # Créer l'array de positions
    @table_hand.positions = @players.map(&:position).sort
    @table_hand.first_player_position = @poker_table.table_hands.empty? ? @table_hand.positions.first : @table_hand.positions[(@poker_table.table_hands.last.positions.index(@poker_table.table_hands.last.first_player_position) + 1) % @table_hand.positions.count]
    @table_hand.current_player_position = @table_hand.positions[(@table_hand.positions.index(@table_hand.first_player_position) + 2) % @table_hand.positions.count]
    @table_hand.status = TableHand::STATUSES[1]
    @table_hand.save
    @players.each do |player|
      player_hand = PlayerHand.new
      player_hand.player = player
      player_hand.player_card1 = pick_a_card
      player_hand.player_card2 = pick_a_card
      player_hand.table_hand = @table_hand
      player_hand.save
    end
    # Putting the small blind
    first_player = @players.find_by(position: @table_hand.first_player_position)
    first_player.stack -= @poker_table.small_blind
    first_player.save
    first_player_hand = first_player.player_hands.last
    first_player_hand.bet_amount += @poker_table.small_blind
    first_player_hand.save
    # Putting the big blind
    second_player_position = @table_hand.positions[(@table_hand.positions.index(@table_hand.first_player_position) + 1) % @table_hand.positions.count]
    second_player = @players.find_by(position: second_player_position)
    second_player.stack -= (@poker_table.small_blind * 2)
    second_player.save
    second_player_hand = second_player.player_hands.last
    second_player_hand.bet_amount += (@poker_table.small_blind * 2)
    second_player_hand.save
    # redering the table
    redirect_to poker_table_path(@poker_table)
  end

  private

  def set_poker_table
    @poker_table = PokerTable.find(params[:poker_table_id])
  end

  def set_table_hand
    @table_hand = current_user.players.last.poker_table.table_hand.last
  end
end
