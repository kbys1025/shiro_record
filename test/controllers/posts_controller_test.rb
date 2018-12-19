require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:a)
    @castle = castles(:one)
    @user = users(:test1)
    @other_user = users(:test2)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      picture = Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures',
                                                      'test.jpg'), 'img/jpg')
      post user_castle_posts_path user_id: @user.id,
                                  castle_id: @castle.id,
                                    params: { post: { picture: picture } }
    end
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_user_castle_post_path(@user, @castle, @post)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_castle_post_path(@user, @castle, @post)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch user_castle_post_path(@user, @castle, @post),
                                  params: { post: { comment: @post.comment } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_castle_post_path(@user, @castle, @post),
                              params: { post: { comment: @post.comment } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Post.count' do
      delete user_castle_post_path(@user, @castle, @post)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong post" do
    log_in_as(users(:test2))
    castle = castles(:one)
    post = posts(:a)
    assert_no_difference 'Post.count' do
      delete user_castle_post_path(@user, castle, post)
    end
    assert_redirected_to root_url
  end
end
