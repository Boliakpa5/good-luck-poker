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
    @player = current_user.players.last
    @player.active = false
    current_user.balance += @player.stack
    @player.save
    current_user.save
    redirect_to root_path
  end
end
