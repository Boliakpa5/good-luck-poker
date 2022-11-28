class PokerTablesController < ApplicationController
  def index
    @poker_tables = PokerTable.all
  end

  def show
    @poker_table = PokerTable.find(params[:id])
  end
end
