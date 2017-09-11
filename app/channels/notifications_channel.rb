class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def speak(data)
  	binding.pry
    # message_params = data['message']
  	# ActionCable.server.broadcast "notifications_channel", message: data['message'], followers: current_user.followers.ids
    message_params = data['message'].each do |el, hash|
      hash[el.values.first] = el.values.last
    end
    binding.pry
    Micropost.create(data['content'])

    # ActionCable.server.broadcast(
    #   "conversations-#{current_user.id}",
    #   message: message_params,
    #   followers: current_user.followers.ids
    # )
  end
end
