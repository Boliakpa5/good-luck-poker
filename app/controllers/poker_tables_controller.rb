class PokerTablesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @poker_tables = PokerTable.all
    @poker_table = PokerTable.new
  end

  def show
    @poker_table = PokerTable.find(params[:id])
    @players = @poker_table.players.active
    @positions = @players.map(&:position).sort
    @table_hand = @poker_table.table_hands.last
  end
end
