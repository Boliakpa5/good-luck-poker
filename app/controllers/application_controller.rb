class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :photo])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :photo])
  end

  def pick_a_card
    @card = @cards.sample
    @cards.delete(@card)
  end

  def refresh_luck_ratio
    hand_counter = 0
    pair_counter = 0
    double_counter = 0
    three_counter = 0
    straight_counter = 0
    flush_counter = 0
    full_counter = 0
    four_counter = 0
    straight_flush_counter = 0
    royal_counter = 0
    players = Player.where(user: current_user)
    # All time counter
    players.each do |player|
      player.player_hands.where.not(combination: nil).each do |player_hand|
        hand_counter += 1
        # high_counter += 1 if player_hand.combination.first == 0
        pair_counter += 1 if player_hand.combination.first == 1
        double_counter += 1 if player_hand.combination.first == 2
        three_counter += 1 if player_hand.combination.first == 3
        straight_counter += 1 if player_hand.combination.first == 4
        flush_counter += 1 if player_hand.combination.first == 5
        full_counter += 1 if player_hand.combination.first == 6
        four_counter += 1 if player_hand.combination.first == 7
        straight_flush_counter += 1 if player_hand.combination.first == 8
        royal_counter += 1 if player_hand.combination.first == 9
      end
    end
    # anti first time crash
    return current_user.update(luck_ratio: 1) if hand_counter.zero?

    # main ratio
    main_ratio = calculateratios(hand_counter, pair_counter, double_counter, three_counter, straight_counter, flush_counter, full_counter, four_counter, straight_flush_counter, royal_counter)
    # saving
    current_user.update(luck_ratio: main_ratio)

    hand_counter = 0
    pair_counter = 0
    double_counter = 0
    three_counter = 0
    straight_counter = 0
    flush_counter = 0
    full_counter = 0
    four_counter = 0
    straight_flush_counter = 0
    royal_counter = 0

    # Daily counter
    players.select { |player| player.created_at >= Date.today }.each do |player|
      player.player_hands.where.not(combination: nil).each do |player_hand|
        hand_counter += 1
        # high_counter += 1 if player_hand.combination.first == 0
        pair_counter += 1 if player_hand.combination.first == 1
        double_counter += 1 if player_hand.combination.first == 2
        three_counter += 1 if player_hand.combination.first == 3
        straight_counter += 1 if player_hand.combination.first == 4
        flush_counter += 1 if player_hand.combination.first == 5
        full_counter += 1 if player_hand.combination.first == 6
        four_counter += 1 if player_hand.combination.first == 7
        straight_flush_counter += 1 if player_hand.combination.first == 8
        royal_counter += 1 if player_hand.combination.first == 9
      end
    end

    # daily ratio
    daily_ratio = calculateratios(hand_counter, pair_counter, double_counter, three_counter, straight_counter, flush_counter, full_counter, four_counter, straight_flush_counter, royal_counter)
    # saving
    (daily_ratio >= current_user.daily_ratio ? current_user.update(increasing_luck: true) : current_user.update(increasing_luck: false)) unless current_user.daily_ratio.nil?
    current_user.update(daily_ratio: daily_ratio)
  end

  def calculateratios(hand_counter, pair_counter, double_counter, three_counter, straight_counter, flush_counter, full_counter, four_counter, straight_flush_counter, royal_counter)

    # means
    pair_mean = pair_counter / hand_counter.to_f
    double_mean = double_counter / hand_counter.to_f
    three_mean = three_counter / hand_counter.to_f
    straight_mean = straight_counter / hand_counter.to_f
    flush_mean = flush_counter / hand_counter.to_f
    full_mean = full_counter / hand_counter.to_f
    four_mean = four_counter / hand_counter.to_f
    straight_flush_mean = straight_flush_counter / hand_counter.to_f
    royal_mean = royal_counter / hand_counter.to_f

    # ratios
    pair_ratio = (pair_mean - 0.422569027611) + 1
    double_ratio = (double_mean - 0.047539015606) + 1
    three_ratio = (three_mean - 0.021128451381) + 1
    straight_ratio = (straight_mean - 0.003924646782) + 1
    flush_ratio = (flush_mean - 0.001965401545) + 1
    full_ratio = (full_mean - 0.00144057623) + 1
    four_ratio = (four_mean - 0.000240096038) + 1
    straight_flush_ratio = (straight_flush_mean - 0.000013851695) + 1
    royal_ratio = (royal_mean - 0.000001539077) + 1

    # main ratio
    ((pair_ratio * 10) + (double_ratio * 5) + three_ratio + straight_ratio + flush_ratio + full_ratio + four_ratio + straight_flush_ratio + royal_ratio) / 24.to_f
  end
end
