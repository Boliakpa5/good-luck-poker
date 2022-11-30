class TableHandsController < ApplicationController
  # STATUSES = %w[bet flop turn river end]
  before_action :set_poker_table, only: [:create]

  def create
    @cards = TableHand::CARDS.dup
    @tablehand = TableHand.new
    @tablehand.poker_table = @poker_table
    @tablehand.current_call_amount = 2 * @tablehand.poker_table.small_blind
    tablehands = TableHand.where(poker_table: @poker_table)
    @tablehand.first_player_position = tablehands.empty? ? 1 : ((tablehands.last.first_player_position + 1 ) % (@poker_table.players.active.count )) + 1
    @tablehand.current_player_position = ((@tablehand.first_player_position + 2) % @poker_table.players.active.count) + 1
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


  private

  def set_poker_table
    @poker_table = PokerTable.find(params[:poker_table_id])
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
