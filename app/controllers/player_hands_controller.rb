class PlayerHandsController < ApplicationController
  before_action :set_player_hand

  def call_hand
  end

  def raise_hand
  end

  def fold_hand
    @player_hand.update(folded: true)
  end

  private

  def set_player_hand
    @player_hand = current_user.player_hands.last
  end
end
