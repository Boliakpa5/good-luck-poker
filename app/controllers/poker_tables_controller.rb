class PokerTablesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if params[:max_players].present?
      @poker_tables = PokerTable.where(max_players: params[:max_players])
      @max_players = params[:max_players]
    elsif params[:small_blind].present?
      @poker_tables = PokerTable.where(small_blind: params[:small_blind])
      big_blind = params[:small_blind].to_i * 2
      @small_blind = "#{params[:small_blind]}-#{big_blind}"
    else
      @poker_tables = PokerTable.all
      @max_players = ""
      @small_blind = ""
    end
    @poker_table = PokerTable.new
  end

  def show
    @poker_table = PokerTable.find(params[:id])
    @players = @poker_table.players.active
    @positions = @players.map(&:position).sort
    @table_hand = @poker_table.table_hands.last
  end
end
