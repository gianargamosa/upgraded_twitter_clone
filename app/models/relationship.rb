# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true 
  validates :followed_id, presence: true
  validate :cant_follow_yourself
  
  # after_create :create_activities


  private
    def cant_follow_yourself
      if follower_id == followed_id
        errors.add(:followed_id, "can't follow yourself")
      end
    end


    # def create_activities
    #   started_following
    #   # was_followed
    # end

    # def started_following
    #   Activity.create(
    #     subject: self,
    #     user: follower   #user doing the following
    #     )
    # end

    # def was_followed
    #   Activity.create(
    #     subject: self,
    #     user: micropost.user_id  #user being favorited
    #     )
    # end
end
