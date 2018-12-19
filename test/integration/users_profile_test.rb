require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:test1)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img'
    assert_match @user.castles.count.to_s, response.body
    assert_select 'div.pagination'
    @user.castles.paginate(page: 1).each do |castle|
      assert_match castle.name, response.body
    end
  end

end
