require 'test_helper'

class CastleTest < ActiveSupport::TestCase

  def setup
    @user = users(:test1)
    picture = Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures',
                                                    'test.jpg'), 'img/jpg')
    @castle = @user.castles.build(picture: picture,
                                      name: "大阪城",
                                  location: "大阪府大阪市",
                                  comment: "大きなお城でした")
  end

  test "should be valid" do
    assert @castle.valid?
  end

  test "user id should be present" do
    @castle.user_id = nil
    assert_not @castle.valid?
  end

  test "name should be present" do
    @castle.name = "  "
    assert_not @castle.valid?
  end

  test "location should be present" do
    @castle.location = "  "
    assert_not @castle.valid?
  end

  test "comment should be present" do
    @castle.comment = "  "
    assert_not @castle.valid?
  end

  test "comment should be at most 255 characters" do
    @castle.comment = "a" * 256
    assert_not @castle.valid?
  end

  test "order should be most recent first" do
    assert_equal castles(:four), Castle.first
  end

  test "associated posts should be destroyed" do
    @castle.save
    picture = Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures',
                                                    'test.jpg'), 'img/jpg')
    @castle.posts.create!(picture: picture)
    assert_difference 'Post.count', -1 do
      @castle.destroy
    end
  end

end
