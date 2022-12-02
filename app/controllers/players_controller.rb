class PlayersController < ApplicationController
  def create
    @poker_table = PokerTable.find(params[:poker_table_id])
    @player = Player.new
    current_user.balance -= 100 * @poker_table.small_blind
    current_user.save
    @player.stack = 100 * @poker_table.small_blind
    @player.user = current_user
    @player.poker_table = @poker_table
    @player.position = params[:position]
    @player.active = true
    if @player.save
      redirect_to poker_table_path(@poker_table)
    else
      render 'views/players/create', status: :unprocessable_entity
    end
  end

  def leave
    current_table_hand = current_user.players.last.poker_table.table_hands.last
    if current_user.players.last.poker_table.players.active.count == 1 && !current_table_hand.nil?
      current_table_hand.status = "end"
      current_table_hand.save
    end
    @player = current_user.players.last
    player_hand = @player.player_hands.last
    unless player_hand.nil?
      player_hand.folded = true
      player_hand.save
    end
    @player.active = false
    current_user.balance += @player.stack
    current_user.save
    @player.save
    redirect_to root_path
  end
end
