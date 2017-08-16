# == Schema Information
#
# Table name: activities
#
#  id           :integer          not null, primary key
#  subject_id   :integer          not null
#  subject_type :string           not null
#  user_id      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Activity < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }
  
  belongs_to :subject, polymorphic: true
  belongs_to :user

  has_one :self_ref, class_name: self, foreign_key: :id
end
