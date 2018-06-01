class RoomChannel < ApplicationCable::Channel
  def subscribed
    puts "sub"
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
