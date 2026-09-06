class RegistrationsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 登録成功時はログイン状態にしてマイページへ
      session[:user_id] = @user.id
      flash[:notice] = "会員登録が完了しました！"
      redirect_to mypage_path
    else
      flash.now[:alert] = "登録に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :investment_policy)
  end
end
