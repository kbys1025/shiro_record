require 'test_helper'

class CastlesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @castle = castles(:one)
    @user = users(:test1)
    @other_user = users(:test2)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Castle.count' do
      post castles_path, params: { castle: { name: "大阪城",
                                            location: "大阪府大阪市",
                                            comment: "大きなお城でした" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_castle_path(@castle)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_castle_path(@castle)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch castle_path(@castle), params: { user: { name: @castle.name,
                                                  location: @castle.location,
                                                  comment: @castle.comment } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch castle_path(@castle), params: { user: { name: @castle.name,
                                                  location: @castle.location,
                                                  comment: @castle.comment } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Castle.count' do
      delete castle_path(@castle)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong castle" do
    log_in_as(users(:test1))
    castle = castles(:four)
    assert_no_difference 'Castle.count' do
      delete castle_path(castle)
    end
    assert_redirected_to root_url
  end

end
