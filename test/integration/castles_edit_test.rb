require 'test_helper'

class CastlesEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test1)
    @castle = castles(:one)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_castle_path(@castle)
    assert_template 'castles/edit'
    patch castle_path(@castle), params: { castle: { name: "", location: "",
                                                    comment: "" } }
    assert_template 'castles/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_castle_path(@castle)
    assert_template 'castles/edit'
    picture = fixture_file_upload('test/fixtures/IMG_0346.jpg', 'image/jpg')
    name = "○○城"
    location = "△県"
    comment = "○△□"
    patch castle_path(@castle), params: { castle: { picture: picture,
                                                      name: name,
                                                    location: location,
                                                    comment: comment } }
    assert_not flash.empty?
    assert_redirected_to @castle
    @castle.reload
    assert assigns(:castle).picture?
    assert_equal name, @castle.name
    assert_equal location, @castle.location
    assert_equal comment, @castle.comment
  end

end
