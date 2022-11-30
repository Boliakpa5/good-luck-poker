class TableHandsController < ApplicationController
  # STATUSES = %w[bet flop turn river end]
  before_action :set_poker_table, only: [:create, :flop, :turn, :river]
  before_action :set_table_hand, only: [:flop, :turn, :river]

  def create
    # .dup pour copier la constante sans la modifier
    @cards = TableHand::CARDS.dup
    @players = @poker_table.players.active
    @table_hand = TableHand.new
    @table_hand.poker_table = @poker_table
    @table_hand.current_call_amount = 2 * @table_hand.poker_table.small_blind
    # Créer l'array de positions
    @table_hand.positions = @players.map(&:position).sort
    @table_hand.first_player_position = @poker_table.table_hands.count == 1 ? @table_hand.positions[0] : @table_hand.positions[(@poker_table.table_hands[-2].positions.index(@poker_table.table_hands[-2].first_player_position) + 1) % @table_hand.positions.count]
    @table_hand.current_player_position = @table_hand.positions[(@table_hand.positions.index(@table_hand.first_player_position) + 2) % @table_hand.positions.count]
    @table_hand.status = TableHand::STATUSES[0]
    @table_hand.save
    @players.each do |player|
      player_hand = PlayerHand.new
      player_hand.player = player
      player_hand.player_card1 = pick_a_card
      player_hand.player_card2 = pick_a_card
      player_hand.table_hand = @table_hand
      player_hand.save
    end
    redirect_to poker_table_path(@poker_table)
  end


  # calcul le score de la main d'un player actif ou non
  def player_hand_score(player)
    score = player.final_hand.score[0]
    score = score.map { |i| i.to_s }
    score = score.map do |num|
      if num.to_i < 10
        "0" + num
      else
        num
      end
    end
    score[0] = score[0] + "."
    score = score.join()
    score = score.to_f
    return score
  end

  # indique si le player win et return true or false
  def player_win?(player)
    if player.active == false
      return false
    else
      end_game_results = []
      @poker_table.players.active.each do |joueur|
        end_game_results << joueur.player_hand_score
      end
      player.player_hand_score == end_game_results.max()
    end
  end

  # indique le type de main (full house, flush, straight, etc..)
  def hand_type(hand)
    hand.hand_rating
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


  private

  def set_poker_table
    @poker_table = PokerTable.find(params[:poker_table_id])
  end

  def set_table_hand
    @table_hand = current_user.players.last.poker_table.table_hand.last
  end

  def pick_a_card
    @card = @cards.sample
    @cards.delete(@card)
  end

  def final_hand
    final_hand = []
    final_hand << player_hand.player_card1
    final_hand << player_hand.player_card2
    final_hand << player_hand.table_hand
    final_hand.flatten!
  end
end
