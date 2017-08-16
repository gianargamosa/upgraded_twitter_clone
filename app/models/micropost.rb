# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  picture    :string
#

class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  has_many :favorites, dependent: :destroy


  has_many :retweet_relationships, class_name: "Retweet", dependent: :destroy
  has_many :retweets, through: :retweet_relationships, source: :micropost


  after_create :create_activity
  after_destroy :destroy_activity

  private
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
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
