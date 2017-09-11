class MicropostBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
  	pry
    # Do something later
  end
end
