require 'test_helper'

class CastlesInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test1)
  end

  test "castle interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # 無効な送信
    assert_no_difference 'Castle.count' do
      post user_castles_path user_id: @user.id,
                                    params: { castle: { name: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'input[type=file]'
    # 有効な送信
    picture = fixture_file_upload('test/fixtures/test.jpg', 'image/jpg')
    name = "a"
    location = "a"
    comment = "a"
    assert_difference 'Castle.count', 1 do
      post user_castles_path(@user, @user.castles.build),
                                        params: { castle: { picture: picture,
                                                               name: name,
                                                           location: location,
                                                            comment: comment } }
    end
    assert assigns(:castle).picture?
    follow_redirect!
    assert_match name, response.body
    assert_match location, response.body
    # 投稿を削除する
    assert_select 'a', text: '削除'
    first_castle = @user.castles.paginate(page: 1).first
    assert_difference 'Castle.count', -1 do
      delete user_castle_path(@user, first_castle)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:test2))
    assert_select 'a', text: '削除', count: 0
  end
end
