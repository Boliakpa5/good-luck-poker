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
      # redirect_to poker_table_path(@poker_table)
      @players = @poker_table.players.active
      @positions = @players.map(&:position).sort
      @table_hand = @poker_table.table_hands.last
      # @html = get_html(@poker_table, @player, @players)
      @html = render_to_string(partial: 'poker_tables/show', locals: {poker_table: @poker_table, players: @players, positions: @positions, table_hand: @table_hand, user: current_user})
      @payload = {
        event: 'player_seated',
        position: @player.position,
        html: @html
      }
      PlayerChannel.broadcast_to(
        current_user,
        @payload
      )
      head :ok
    end
  end

  def leave
    poker_table = current_user.players.active.last.poker_table
    current_table_hand = poker_table.table_hands.last
    @player = current_user.players.active.last
    @player.active = false
    @player.save
    if poker_table.players.active.count <= 1 && !current_table_hand.nil?
      current_table_hand.status = "end"
      current_table_hand.save
    end
    player_hand = @player.player_hands.last
    unless player_hand.nil?
      player_hand.folded = true
      player_hand.save
    end
    current_user.balance += @player.stack
    current_user.save
    redirect_to poker_tables_path(poker_table)
  end
end
