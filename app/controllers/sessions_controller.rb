class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "ログインしました"
      redirect_to mypage_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    flash[:notice] = "ログアウトしました"
    redirect_to root_path
  end

  # ゲストログイン機能
  def guest_login
    user = User.find_or_create_by!(email: "guest@example.com") do |u|
      u.name = "ゲストユーザー"
      u.password = SecureRandom.urlsafe_base64
      u.investment_policy = "【ゲストお試し用】感情に振り回されずに検証を行う"
    end
    session[:user_id] = user.id
    flash[:notice] = "ゲストユーザーとしてログインしました"
    redirect_to mypage_path
  end
end
