class PokerTablesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @poker_tables = PokerTable.all
  end

  def show
    @poker_table = PokerTable.find(params[:id])
    @players = Player.where(poker_table: @poker_table)
  end
end
