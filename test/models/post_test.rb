require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @castle = castles(:one)
    picture = Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures',
                                                    'test.jpg'), 'img/jpg')
    @post = @castle.posts.build(picture: picture)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "castle id should be present" do
    @post.castle_id = nil
    assert_not @post.valid?
  end

  test "comment should be at most 50 characters" do
    @post.comment = "a" * 51
    assert_not @post.valid?
  end

end
