require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:a)
    @castle = castles(:one)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      picture = Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures',
                                                      'test.jpg'), 'img/jpg')
      post castle_posts_path castle_id: @castle.id,
                              params: { post: { picture: picture } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Post.count' do
      delete castle_post_path(@castle, @post)
    end
    assert_redirected_to login_url
  end
end
