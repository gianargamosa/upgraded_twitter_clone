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

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Jacob Powers", email: "test@test2.com",
                      password: 'foobar', password_confirmation: 'foobar')
  end

  test "should be valid" do 
    assert @user.valid?
  end

  #name tests
  test "name should be present" do
    @user.name = '     '
    assert_not @user.valid?
  end

  test "name should be not too long" do
    @user.name = 'a'*51
    assert_not @user.valid?
  end


  #email tests
  test "email should be present" do
    @user.email = '     '
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = 'a'*244 + '@example.com'
    assert_not @user.valid?
  end

  test "should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid? "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExaMpLE.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  #password tests
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = 'a'*5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end


  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end
  

  test "should follow and unfollow a user" do
    jacob   = users(:jacob)
    archer  = users(:archer)
    assert_not jacob.following?(archer)
    jacob.follow(archer)
    assert jacob.following?(archer)
    assert archer.followers.include?(jacob)
    jacob.unfollow(archer)
    assert_not jacob.following?(archer)
  end

  test "should have the right posts" do
    jacob = users(:jacob)
    archer = users(:archer)
    lana = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert jacob.feed.include?(post_following)
    end
    # Posts from self
    jacob.microposts.each do |post_self|
      assert jacob.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not jacob.feed.include?(post_unfollowed)
    end
  end


  
end
