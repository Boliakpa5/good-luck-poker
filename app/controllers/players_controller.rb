class PlayersController < ApplicationController
  def create
    @poker_table = PokerTable.find(params[:poker_table_id])
    @current_player = Player.new
    current_user.balance -= 100 * @poker_table.small_blind
    current_user.save
    @current_player.stack = 100 * @poker_table.small_blind
    @current_player.user = current_user
    @current_player.poker_table = @poker_table
    @current_player.position = params[:position]
    @current_player.active = true
    if @current_player.save
      # redirect_to poker_table_path(@poker_table)
      @players = @poker_table.players.active
      @positions = @players.map(&:position).sort
      @table_hand = @poker_table.table_hands.last
      # @html = get_html(@poker_table, @player, @players)
      @players.each do |player|
        @html = render_to_string(partial: 'poker_tables/show', locals: {poker_table: @poker_table, players: @players, positions: @positions, table_hand: @table_hand, player: player})
        @payload = {
          event: 'player_seated',
          position: @current_player.position,
          html: @html
        }
        PlayerChannel.broadcast_to(
          player,
          @payload
        )
      end
    end
    redirect_to poker_table_path(@poker_table)
  end

  def leave
    @poker_table = current_user.players.active.last.poker_table
    current_table_hand = @poker_table.table_hands.last
    @player = current_user.players.active.last
    @player.active = false
    @player.save
    if @poker_table.players.active.count <= 1 && !current_table_hand.nil?
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
    if current_user.save
      @players = @poker_table.players.active
      @positions = @players.map(&:position).sort
      @table_hand = @poker_table.table_hands.last
      @players.each do |player|
        @html = render_to_string(partial: 'poker_tables/show', locals: {poker_table: @poker_table, players: @players, positions: @positions, table_hand: @table_hand, player: player})
        @payload = {
          event: 'player_leaving',
          html: @html
        }
        PlayerChannel.broadcast_to(
          player,
          @payload
        )
      end
    end
    redirect_to poker_table_path(@poker_table)
  end

  # private

  # def get_html(poker_table, player, players)
  #   case poker_table.max_players
  #   when 5
  #     case player.position
  #     when 1 then render_to_string(partial: "poker_tables/seat_left", locals: { players: players, poker_table: poker_table, position: 1 })
  #     when 2 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 2 })
  #     when 3 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 3 })
  #     when 4 then render_to_string(partial: "poker_tables/seat_right", locals: { players: players, poker_table: poker_table, position: 4 })
  #     when 5 then render_to_string(partial: "poker_tables/seat_bottom", locals: { players: players, poker_table: poker_table, position: 5 })
  #     end
  #   when 6
  #     case player.position
  #     when 1 then render_to_string(partial: "poker_tables/seat_left", locals: { players: players, poker_table: poker_table, position: 1 })
  #     when 2 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 2 })
  #     when 3 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 3 })
  #     when 4 then render_to_string(partial: "poker_tables/seat_right", locals: { players: players, poker_table: poker_table, position: 4 })
  #     when 5 then render_to_string(partial: "poker_tables/seat_bottom", locals: { players: players, poker_table: poker_table, position: 5 })
  #     end
  #   when 7
  #     case player.position
  #     when 1 then render_to_string(partial: "poker_tables/seat_left", locals: { players: players, poker_table: poker_table, position: 1 })
  #     when 2 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 2 })
  #     when 3 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 3 })
  #     when 4 then render_to_string(partial: "poker_tables/seat_right", locals: { players: players, poker_table: poker_table, position: 4 })
  #     when 5 then render_to_string(partial: "poker_tables/seat_bottom", locals: { players: players, poker_table: poker_table, position: 5 })
  #     end
  #   when 8
  #     case player.position
  #     when 1 then render_to_string(partial: "poker_tables/seat_left", locals: { players: players, poker_table: poker_table, position: 1 })
  #     when 2 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 2 })
  #     when 3 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 3 })
  #     when 4 then render_to_string(partial: "poker_tables/seat_right", locals: { players: players, poker_table: poker_table, position: 4 })
  #     when 5 then render_to_string(partial: "poker_tables/seat_bottom", locals: { players: players, poker_table: poker_table, position: 5 })
  #     end
  #   when 9
  #     case player.position
  #     when 1 then render_to_string(partial: "poker_tables/seat_left", locals: { players: players, poker_table: poker_table, position: 1 })
  #     when 2 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 2 })
  #     when 3 then render_to_string(partial: "poker_tables/seat_top", locals: { players: players, poker_table: poker_table, position: 3 })
  #     when 4 then render_to_string(partial: "poker_tables/seat_right", locals: { players: players, poker_table: poker_table, position: 4 })
  #     when 5 then render_to_string(partial: "poker_tables/seat_bottom", locals: { players: players, poker_table: poker_table, position: 5 })
  #     end
  #   end
  # end
end
