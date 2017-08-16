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

require 'test_helper'

class RetweetTest < ActiveSupport::TestCase

  def setup
    @user = users(:jacob)
    @other = users(:archer)
    @micropost = @other.microposts.create!(content: "This is Archer")
    @retweet = Retweet.new(user_id: @user.id, micropost_id: @micropost.id)
  end

  test "should be valid" do
    assert @retweet.valid?
  end

  test "should require a user_id" do
    @retweet.user_id = nil
    assert_not @retweet.valid?
  end

  test "should require a micropost_id" do
    @retweet.micropost_id = nil
    assert_not @retweet.valid?
  end
  
  test "should not have the same ids" do
    @retweet.user_id = @other.id
    assert_not @retweet.valid?
  end

end
