class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy,
                                          :following, :followers]
  before_action :correct_user,    only: [:edit, :update, :favorites]
  before_action :admin_user,      only: :destroy

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def favorites
    @title = "Favorites"
    @user = User.find(params[:id])
    @favorites = @user.favorites.paginate(page: params[:page])
  end

  def retweets
    @title = "Retweets"
    @user = User.find(params[:id])
    @retweets = @user.retweeted.paginate(page: params[:page])
  end


  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @activities = @user.user_feed.paginate(page: params[:page])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    #before filters
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end


    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
