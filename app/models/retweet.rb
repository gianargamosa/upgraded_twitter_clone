# == Schema Information
#
# Table name: retweets
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  micropost_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Retweet < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user

  default_scope -> { order(created_at: :desc) }
  validates :micropost_id, presence: true
  validates :user_id, presence: true
  validate :cant_retweet_yourself

  after_create :create_activity
  after_destroy :destroy_activity

  private
    def cant_retweet_yourself
      if Micropost.exists?(micropost_id)
        if user_id == Micropost.find_by(id: micropost_id).user_id
          errors.add(:user_id, "can't retweet self")
        end
      else
        errors.add(:micropost_id, "can't find micropost")
      end
    end

    def create_activity
      Activity.create(
        subject: self,
        user: user
        )
    end

    def destroy_activity
      Activity.find_by(
        subject: self,
        user: user
        ).destroy
    end
end
