# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default("f")
#  activation_digest :string
#  activated         :boolean          default("f")
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#

class User < ActiveRecord::Base

  has_many :microposts, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :favorited_items, class_name: "Favorite", dependent: :destroy
  has_many :favorites, through: :favorited_items, source: :micropost
  
  has_many :retweet_relationships, class_name: "Retweet", dependent: :destroy
  has_many :retweeted, through: :retweet_relationships, source: :micropost

  has_many :activities, dependent: :destroy
  has_many :feed_items, through: :activities, source: :subject, source_type: "Micropost"

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  
  #name validations
  validates(
    :name,
      presence: true,
      length:  { maximum: 50 }
  )
  

  #email validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(
    :email, 
      presence: true,
      length: { maximum: 255 },
      format: { with: VALID_EMAIL_REGEX },
      uniqueness: { case_sensitive: false }
  )


  #password validations
  has_secure_password
  validates( :password, length: {minimum: 6}, allow_blank: true )


  # Activate an account.
  def activate
    update_columns( activated: true, activated_at: Time.zone.now )
  end
  
  # Return true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

    # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token),
                   reset_sent_at: Time.zone.now )
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"

    Micropost.joins(:user).where("user_id IN (#{following_ids})
                      OR user_id = :user_id", user_id: id)
  end

  def active_feed
    following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"
    
    Activity.where("user_id IN (#{following_ids})
                      OR user_id = :user_id", user_id: id)
  end

  def user_feed
    Activity.where(user_id: id)
  end


  # Follows a user.
  def follow(other_user)
    active_relationships.create( followed_id: other_user.id )
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by( followed_id: other_user.id).destroy
  end

  def favorite(micropost)
    if !self.favorited?(micropost)
      micropost.favorites.create(user_id: self.id)
    else
      Favorite.find_by(user_id: self.id,
             micropost_id: micropost.id).destroy
    end
  end

  def favorited?(micropost)
    Favorite.exists?(user_id: self.id, micropost_id: micropost.id)
  end



  def retweet(micropost)
    if !self.retweeted?(micropost)
      Retweet.create(user_id: self.id, micropost_id: micropost.id)
    else
      Retweet.find_by(user_id: self.id, micropost_id: micropost.id).destroy
    end
  end

  def retweeted?(micropost)
    Retweet.exists?(user_id: self.id, micropost_id: micropost.id)
  end



  # Returns true if current user is following another user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Send activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Return the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
          BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end




  private

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def downcase_email
      self.email.downcase!
    end
end



