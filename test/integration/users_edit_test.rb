require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  #編集失敗時のテスト
  test "unsuccessful edit" do
    log_in_as(@user)
    #1. 編集ページにアクセス
    get edit_user_path(@user)
    #2. 無効な情報を送信
    patch user_path(@user), params: { user: { name: "",
                            email: "foo@invalid",
                            password: "foo",
                            password_confirmation: "bar"}}
    #3. editビューの再描画
    assert_template 'users/edit'
    # 演習で追加
    assert_select "div.alert", "The form contains 4 errors."
  end

  #ユーザー情報を更新する正しい振る舞いテスト
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                            email: email,
                            password: "",
                            password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  #フレンドリーフォワーディングのテスト
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user) #演習で追加
    log_in_as(@user)
    assert_nil session[:forwarding_url]   #演習で追加
    assert_redirected_to edit_user_url(@user)
    name　= "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end


end
