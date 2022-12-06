class PlayerChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    user = current_user
    stream_for user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
