require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com", 
              password: "foobar", password_confirmation: "foobar")
  end

  #Userオブジェクトの有効性（Userモデルが機能しているか）
  test "should be valid" do
    assert @user.valid?
  end

  #存在性に関するテスト
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  #文字数チェック
  #1.エラーとなるデータを作成
  #2.文字数チェックのバリデーションが機能すれば自動で排除するのでエラーにならない
  #3.バリデーションが機能していなければ、@user.valid?でfalseを返すためエラー検知する
  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end

  #メールのフォーマットチェック（有効なメールフォーマット）
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  #メールのフォーマットチェック（無効なメールフォーマット）
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  #一意性をチェック
  #1.同じ属性を持つデータを複製
  #2.一意性を保つバリデーションが機能していれば@user.saveの後では、複製データは弾かれてテストは合格する
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  #メールアドレスの小文字化に対するテスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  #パスワードの未入力チェック
  test "password should be present(nonblank)" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  #パスワードの最小文字数チェック
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  #２種類ブラウザシュミレートテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
end
