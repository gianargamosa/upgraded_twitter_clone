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

require 'test_helper'


class FavoriteTest < ActiveSupport::TestCase

  def setup
    @user  = users(:jacob)
    @other = users(:archer)
    @favorite = @user.favorite(@other.microposts.first )
  end

  test "is valid" do
    assert @favorite.valid?
  end

  test "is invalid with no user" do
    @favorite.user_id = nil
    assert_not @favorite.valid?
  end

  test "is invalid with no micropost" do
    @favorite.micropost_id = nil
    assert_not @favorite.valid?
  end
end
