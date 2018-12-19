require 'test_helper'

class CastlesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @castle = castles(:one)
    @user = users(:test1)
    @other_user = users(:test2)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Castle.count' do
      post user_castles_path user_id: @user.id,
                                    params: { castle: { name: "大阪城",
                                            location: "大阪府大阪市",
                                            comment: "大きなお城でした" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_user_castle_path(@user, @castle)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_castle_path(@user, @castle)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch user_castle_path(@user, @castle),
                                    params: { castle: { name: @castle.name,
                                                  location: @castle.location,
                                                   comment: @castle.comment } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_castle_path(@user, @castle),
                                    params: { castle: { name: @castle.name,
                                                  location: @castle.location,
                                                   comment: @castle.comment } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Castle.count' do
      delete user_castle_path(@user,@castle)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong castle" do
    log_in_as(users(:test2))
    castle = castles(:one)
    assert_no_difference 'Castle.count' do
      delete user_castle_path(@user, castle)
    end
    assert_redirected_to root_url
  end

end
