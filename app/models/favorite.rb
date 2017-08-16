# == Schema Information
#
# Table name: favorites
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  micropost_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Favorite < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user

  default_scope -> { order(created_at: :desc) }
  validates :micropost_id, presence: true
  validates :user_id, presence: true
end
