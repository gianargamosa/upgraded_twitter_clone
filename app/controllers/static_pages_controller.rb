class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @activities = current_user.active_feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
