class PlayersController < ApplicationController
  def create
    @poker_table = PokerTable.find(params[:poker_table_id])
    @player = Player.new
    @player.stack = 100 * @poker_table.small_blind
    @player.user = current_user
    @player.poker_table = @poker_table
    @player.position = 1
    if @player.save
      redirect_to poker_table_path(@poker_table)
    else
      render 'views/players/create', status: :unprocessable_entity
    end
  end

  def leave
    @player = Player.find(params[:id])
    @player.active = false
    @player.save
    redirect_to root_path
  end

end
