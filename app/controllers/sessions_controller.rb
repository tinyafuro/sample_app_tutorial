class SessionsController < ApplicationController
  
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user       #ログイン処理
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) #rememberチェック確認
      # remember @user     #永続セッションのためにremember_tokenを生成して保存
      redirect_to @user  #ログイン後ユーザーページへ自動的にリダイレクト
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end