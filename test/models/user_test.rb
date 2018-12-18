require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

  test "associated castles should be destroyed" do
    @user.save
    picture = Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures',
                                                    'test.jpg'), 'img/jpg')
    @user.castles.create!(picture: picture, name: "大阪城",
                          location: "大阪府大阪市", comment: "大きなお城でした")
    assert_difference 'Castle.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    test1 = users(:test1)
    test2 = users(:test2)
    assert_not test1.following?(test2)
    test1.follow(test2)
    assert test1.following?(test2)
    assert test2.followers.include?(test1)
    test1.unfollow(test2)
    assert_not test1.following?(test2)
  end

  test "feed should have the right castles" do
    test1 = users(:test1)
    test2 = users(:test2)
    test3 = users(:test3)
    # フォローしているユーザーの投稿を確認
    test3.castles.each do |castle_following|
      assert test1.feed.include?(castle_following)
    end
    # 自分自身の投稿を確認
    test1.castles.each do |castle_self|
      assert test1.feed.include?(castle_self)
    end
    # フォローしていないユーザーの投稿を確認
    test2.castles.each do |castle_unfollowed|
      assert_not test1.feed.include?(castle_unfollowed)
    end
  end

end
