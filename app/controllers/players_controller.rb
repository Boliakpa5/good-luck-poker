class PlayersController < ApplicationController
  def create
    @poker_table = PokerTable.find(:table_id)
    @player = Player.new(player_params)
    @player.user = current_user
    @player.poker_table = @poker_table
    # @player.position = ?????????
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

  # private

  # def player_params
  #   params.require(:player).permit(:stack)
  # end
end
