class PlayerHandsController < ApplicationController
  before_action :set_current_things

  def call_hand
    call_amount = @table_hand.current_call_amount - @hand.bet_amount
    if @player.stack >= call_amount
      @player.stack -= call_amount
      @hand.bet_amount += call_amount
    else
      @hand.bet_amount += @player.stack
      @player.stack = 0
    end
    @player.save
    @hand.save
    next_player
  end

  def raise_hand
    raise_amount = params[:raise_amount].to_i
    @player.stack -= raise_amount
    @player.save
    @hand.bet_amount += raise_amount
    @hand.save
    bet_amounts = []
    @players.each do |p|
      bet_amounts << p.player_hands.last.bet_amount
    end
    @table_hand.current_call_amount = bet_amounts.max
    @table_hand.counter = 0
    @table_hand.save
    next_player
  end

  def fold_hand
    @hand.folded = true
    @hand.save
    next_player
  end

  def leave
    unless @hand.nil?
      @hand.folded = true
      @hand.save
    end
    @player.active = false
    @player.save
    current_user.balance += @player.stack
    current_user.save
    if @poker_table.players.active.count.zero? && !@table_hand.nil?
      @table_hand.status = "end"
      @table_hand.save
    end
    next_player_without_render if @table_hand.current_player_position == @player.position
    if current_user.save
      @positions = @players.map(&:position).sort
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

  private

  def set_current_things
    @hand = current_user.player_hands.find(params[:id])
    @poker_table = @hand.table_hand.poker_table
    @player = @hand.player
    @players = @poker_table.players.active
    @table_hand = @hand.table_hand
    @unfolded_hands = @table_hand.player_hands.where(folded: false)
  end

  def set_pot
    @players.each do |player|
      @table_hand.pot += player.player_hands.last.bet_amount
      player.player_hands.last.update(bet_amount: 0)
    end
    @table_hand.update(current_call_amount: 0)
  end

  def next_player
    @table_hand.counter += 1
    positions = @table_hand.positions
    if @unfolded_hands.count == 1
      prepare_cards
      set_pot
      raise
      # @table_hand.table_card1 = pick_a_card if @table_hand.table_card1.nil?
      # @table_hand.table_card2 = pick_a_card if @table_hand.table_card2.nil?
      # @table_hand.table_card3 = pick_a_card if @table_hand.table_card3.nil?
      # @table_hand.table_card4 = pick_a_card if @table_hand.table_card4.nil?
      # @table_hand.table_card5 = pick_a_card if @table_hand.table_card5.nil?
      endgame(@unfolded_hands.first.player)
      return
    end
    if @table_hand.counter >= positions.count
      prepare_cards
      case @table_hand.status
      when 'preflop' then flop
      when 'flop' then turn
      when 'turn' then river
      when 'river' then calculatewinner
      end
    else
      index_of_next_player = (positions.index(@table_hand.current_player_position) + 1) % positions.count
      @table_hand.current_player_position = positions[index_of_next_player]
      @table_hand.save

      if @players.reload.find_by(position: @table_hand.current_player_position).nil? || @players.reload.find_by(position: @table_hand.current_player_position).player_hands.last.folded == true || @poker_table.players.active.find_by(position: @table_hand.current_player_position).stack <= 0 || @players.find_by(position: @table_hand.current_player_position).nil?
        next_player
        return
      end
      if @table_hand.save
        @positions = @players.map(&:position).sort
        @players.each do |player|
          @html = render_to_string(partial: 'poker_tables/show', locals: {poker_table: @poker_table, players: @players, positions: @positions, table_hand: @table_hand, player: player})
          @payload = {
            event: 'next_player',
            player: player.id,
            html: @html
          }
          PlayerChannel.broadcast_to(
            player,
            @payload
          )
        end
        head :ok
      end
      # redirect_to poker_table_path(@poker_table)
    end
  end

  def next_player_without_render
    positions = @table_hand.positions
    index_of_next_player = (positions.index(@table_hand.current_player_position) + 1) % positions.count
    @table_hand.current_player_position = positions[index_of_next_player]
    @table_hand.counter += 1
    @table_hand.save
    if @table_hand.counter >= positions.count
      prepare_cards
      case @table_hand.status
      when 'preflop' then flop
      when 'flop' then turn
      when 'turn' then river
      when 'river' then calculatewinner
      end
    end
    if @players.reload.find_by(position: @table_hand.current_player_position).nil? || @players.reload.find_by(position: @table_hand.current_player_position).player_hands.last.folded == true || @players.find_by(position: @table_hand.current_player_position).stack <= 0 || @players.find_by(position: @table_hand.current_player_position).active == false
      next_player_without_render
    end
  end

  def flop
    set_pot
    @table_hand.table_card1 = pick_a_card
    @table_hand.table_card2 = pick_a_card
    @table_hand.table_card3 = pick_a_card
    @table_hand.status = TableHand::STATUSES[2]
    @table_hand.counter = 0
    @table_hand.current_player_position = @table_hand.first_player_position
    if @players.reload.find_by(position: @table_hand.current_player_position).nil? || @players.reload.find_by(position: @table_hand.current_player_position).player_hands.last.folded == true || @players.find_by(position: @table_hand.current_player_position).stack <= 0 || @players.find_by(position: @table_hand.current_player_position).active == false
      next_player_without_render
    end
    @table_hand.save
    if @table_hand.save
      @positions = @players.map(&:position).sort
      @players.each do |player|
        @html = render_to_string(partial: 'poker_tables/show', locals: {poker_table: @poker_table, players: @players, positions: @positions, table_hand: @table_hand, player: player})
        @payload = {
          event: 'flop',
          player: player.id,
          html: @html
        }
        PlayerChannel.broadcast_to(
          player,
          @payload
        )
      end
      head :ok
    end
    # redirect_to poker_table_path(@poker_table)
  end

  def turn
    set_pot
    @table_hand.table_card4 = pick_a_card
    @table_hand.status = TableHand::STATUSES[3]
    # @table_hand.current_call_amount = 0
    @table_hand.counter = 0
    if @players.reload.find_by(position: @table_hand.current_player_position).nil? || @players.reload.find_by(position: @table_hand.current_player_position).player_hands.last.folded == true || @players.find_by(position: @table_hand.current_player_position).stack <= 0 || @players.find_by(position: @table_hand.current_player_position).active == false
      next_player_without_render
    else
      @table_hand.current_player_position = @table_hand.first_player_position
    end
    @table_hand.save
    if @table_hand.save
      @positions = @players.map(&:position).sort
      @players.each do |player|
        @html = render_to_string(partial: 'poker_tables/show', locals: {poker_table: @poker_table, players: @players, positions: @positions, table_hand: @table_hand, player: player})
        @payload = {
          event: 'turn',
          html: @html
        }
        PlayerChannel.broadcast_to(
          player,
          @payload
        )
      end
      head :ok
    end
    # redirect_to poker_table_path(@poker_table)
  end

  def river
    set_pot
    @table_hand.table_card5 = pick_a_card
    @table_hand.status = TableHand::STATUSES[4]
    # @table_hand.current_call_amount = 0
    @table_hand.counter = 0
    if @players.reload.find_by(position: @table_hand.current_player_position).nil? || @players.reload.find_by(position: @table_hand.current_player_position).player_hands.last.folded == true || @players.find_by(position: @table_hand.current_player_position).stack <= 0 || @players.find_by(position: @table_hand.current_player_position).active == false
      next_player_without_render
    else
      @table_hand.current_player_position = @table_hand.first_player_position
    end
    @table_hand.save
    if @table_hand.save
      @positions = @players.map(&:position).sort
      @players.each do |player|
        @html = render_to_string(partial: 'poker_tables/show', locals: {poker_table: @poker_table, players: @players, positions: @positions, table_hand: @table_hand, player: player})
        @payload = {
          event: 'river',
          html: @html
        }
        PlayerChannel.broadcast_to(
          player,
          @payload
        )
      end
      head :ok
    end
    # redirect_to poker_table_path(@poker_table)
  end

  def prepare_cards
    @cards = TableHand::CARDS.dup
    @table_hand.player_hands.each do |player_hand|
      @cards.delete(player_hand.player_card1)
      @cards.delete(player_hand.player_card2)
    end
    @cards.delete(@table_hand.table_card1)
    @cards.delete(@table_hand.table_card2)
    @cards.delete(@table_hand.table_card3)
    @cards.delete(@table_hand.table_card4)
  end

  def calculatewinner
    @players.each do |player|
      playerhand = player.player_hands.last
      card_array = []
      card_array << playerhand.player_card1
      card_array << playerhand.player_card2
      card_array << @table_hand.table_card1
      card_array << @table_hand.table_card2
      card_array << @table_hand.table_card3
      card_array << @table_hand.table_card4
      card_array << @table_hand.table_card5
      card_array.map! do |card|
        case card.first
        when "T" then card.gsub("T", "10")
        when "J" then card.gsub("J", "11")
        when "Q" then card.gsub("Q", "12")
        when "K" then card.gsub("K", "13")
        when "A" then card.gsub("A", "14")
        else card
        end
      end
      numbers_array = []
      color_array = []
      card_array.each do |card|
        numbers_array << card.chop.to_i
        color_array << card.last
      end
      numbers_array.sort!
      # Needed for double pairs
      hash = numbers_array.tally
      # Needed for flushes
      if color_array.tally.values.max >= 5
        color_number_array = []
        card_array.each do |card|
          color_number_array << card.chop.to_i if card.last == color_array.tally.key(5) || color_array.tally.key(6) || color_array.tally.key(7)
        end
        color_number_array.sort!
      end
      # Royal Flush
      if color_array.tally.values.max >= 5 && suited(color_number_array) == 14
        playerhand.combination = [9]
      # Straight Flush
      elsif color_array.tally.values.max >= 5 && suited(color_number_array.reject { |i| i == 1 })
        playerhand.combination = [8, suited(color_number_array.reject { |i| i == 1 })]
      # Four of a Kind
      elsif numbers_array.tally.values.max == 4
        playerhand.combination = [7, numbers_array.tally.key(4)]
      # Full House
      elsif numbers_array.tally.values.max == 3 && numbers_array.tally.value?(2)
        playerhand.combination = [6, numbers_array.tally.key(3)]
      # Flush
      elsif color_array.tally.values.max >= 5
        playerhand.combination = [5, color_number_array.max]
      # Straight
      elsif suited(numbers_array)
        playerhand.combination = [4, suited(numbers_array)]
      # Three of a kind
      elsif numbers_array.tally.values.max == 3
        playerhand.combination = [3, numbers_array.tally.key(3)]
      # Double Pair
      elsif !hash.values.count(2).nil? && hash.values.count(2) >= 2
        playerhand.combination = [2, hash.keys[hash.values.rindex(2)], hash.keys[hash.values.index(2)], hash.keys[hash.values.rindex(1)]]
        # !!!!! Va prendre la plus petite paire des 3 au lieu de la deuxieme au cas ou il y a plus que 2 paires !!!!!
      # Pair
      elsif hash.values.tally[2] == 1
        double_array = []
        card_array.each do |card|
          double_array << card.chop.to_i
        end
        double_array.delete(hash.keys[hash.values.rindex(2)])
        last_cards = double_array.sort!.reverse.first(3)
        combination = [1, hash.keys[hash.values.rindex(2)], last_cards].flatten
        playerhand.combination = combination
      # High Card
      else
        single_array = []
        card_array.each do |card|
          single_array << card.chop.to_i
        end
        last_cards = single_array.sort!.reverse.first(5)
        combination = [0, last_cards].flatten
        playerhand.combination = combination
      end
      player.save
      playerhand.save
    end
    winner = getwinner
    endgame(winner)
  end

  def getwinner
    comparative_array = []
    winners = []
    @players.each do |player|
      comparative_array << player.player_hands.last.combination if player.player_hands.last.folded == false
    end
    winningcombination = comparative_array.max
    # raise
    if comparative_array.count(comparative_array.max) >= 2
      @players.each do |player|
        winners << player if player.player_hands.last.combination == winningcombination
      end
      return winners
    else
      @players.each do |player|
        return player if player.player_hands.last.combination == winningcombination
      end
    end
    # !!!!!!!! NE PREND PAS EN COMPTE LE ALL IN (all in a 5 peut gagenr 20k)!!!!!!!!!!!!
  end

  def suited(sorted_number_array)
    array_of_ones = []
    aces = sorted_number_array.count(14)
    aces.times { sorted_number_array << 1 } if aces >= 1
    sorted_number_array.sort.uniq.each_cons(5) do |pack|
      pack.each_cons(2) do |pair|
        array_of_ones << (pair.last - pair.first)
      end
    end
    max = array_of_ones.count
    if max >= 4 && !array_of_ones[max - 4, 4].tally[1].nil? && array_of_ones[max - 4, 4].tally[1] >= 4
      index = array_of_ones[max - 4, 4].rindex(1)
      return sorted_number_array[index + 3]
    elsif max >= 8 &&  !array_of_ones[max - 8, 4].tally[1].nil? && array_of_ones[max - 8, 4].tally[1] >= 4
      index = array_of_ones[max - 8, 4].rindex(1)
      return sorted_number_array[index + 2]
    elsif max >= 12 && !array_of_ones[max - 12, 4].tally[1].nil? && array_of_ones[max - 12, 4].tally[1] >= 4
      index = array_of_ones[max - 12, 4].rindex(1)
      return sorted_number_array[index + 1]
    end
    return nil
  end

  def endgame(winner)
    @table_hand.status = TableHand::STATUSES[0]
    @table_hand.save
    if winner.instance_of?(Array)
      winner.each do |i|
        winnerhand = i.player_hands.last
        winnerhand.winner = true
        winnerhand.save
        i.stack += (@table_hand.pot / winner.count)
        i.save
      end
    else
      winnerhand = winner.player_hands.last
      winnerhand.winner = true
      winnerhand.save
      winner.stack += @table_hand.pot
      winner.save

    end
    @players.reload.each do |player|
      if player.stack <= (@poker_table.small_blind * 2)
        player.active = false
        player.save
        player.user.balance += player.stack
        player.user.save
      end
    end

    if @table_hand.save
      @positions = @players.map(&:position).sort
      @table_hand.players.each do |player|
        @html = render_to_string(partial: 'poker_tables/show', locals: {poker_table: @poker_table, players: @players, positions: @positions, table_hand: @table_hand, player: player})
        @payload = {
          event: 'end_game',
          html: @html
        }
        PlayerChannel.broadcast_to(
          player,
          @payload
        )
      end
      head :ok
    end
    # redirect_to poker_table_path(@poker_table)
  end
end
