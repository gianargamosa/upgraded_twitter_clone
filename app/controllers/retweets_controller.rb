class RetweetsController < ApplicationController
  before_action :logged_in_user, only: [:update]


  # retweets or un-retweets post
  def update
    @micropost = Micropost.find(params[:micropost_id])
    current_user.retweet(@micropost)
    respond_to do |format|
      format.html { redirect_to "/static_pages/home"}
      format.js
    end
  end


end