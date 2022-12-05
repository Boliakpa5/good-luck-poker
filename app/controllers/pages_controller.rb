class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    if user_signed_in?
      refresh_luck_ratio
    end
  end

  def reset
    current_user.update(balance: 500)
    redirect_to root_path
  end
end
