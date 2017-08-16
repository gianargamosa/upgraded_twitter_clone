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

require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:jacob)
    # This code is not idiomatically correct.
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end


  test "is valid" do
    assert @micropost.valid?    
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end


  test "content should be present" do
    @micropost.content = "    "
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do 
    assert_equal Micropost.first, microposts(:most_recent)
  end
end
