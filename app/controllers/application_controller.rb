class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
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
      player.player_hands.where(folded: false).each do |player_hand|
        hand_counter += 1
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
    hand_counter = 1 if hand_counter.zero?
    # means
    pair_mean = pair_counter / hand_counter
    double_mean = double_counter / hand_counter
    three_mean = three_counter / hand_counter
    straight_mean = straight_counter / hand_counter
    flush_mean = flush_counter / hand_counter
    full_mean = full_counter / hand_counter
    four_mean = four_counter / hand_counter
    straight_flush_mean = straight_flush_counter / hand_counter
    royal_mean = royal_counter / hand_counter

    # ratios
    pair_ratio = pair_mean / 42.2569027611
    double_ratio = double_mean / 4.7539015606
    three_ratio = three_mean / 2.1128451381
    straight_ratio = straight_mean / 0.3924646782
    flush_ratio = flush_mean / 0.1965401545
    full_ratio = full_mean / 0.144057623
    four_ratio = four_mean / 0.0240096038
    straight_flush_ratio = straight_flush_mean / 0.0013851695
    royal_ratio = royal_mean / 0.0001539077

    # main ratio
    main_ratio = (pair_ratio + double_ratio + three_ratio + straight_ratio + flush_ratio + full_ratio + four_ratio + straight_flush_ratio + royal_ratio) / 9

    # saving
    current_user.update(luck_ratio: main_ratio)
  end
end
