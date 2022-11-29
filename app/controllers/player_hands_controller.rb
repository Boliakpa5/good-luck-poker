class PlayerHandsController < ApplicationController
  before_action :set_player_hand

  def call_hand
  end

  def raise_hand
  end

  def fold_hand
  end

  private

  def set_player_hand
    @player_hand = PlayerHand.find(params[:id])
  end
end
