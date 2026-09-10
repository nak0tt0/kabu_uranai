class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def show
    @user = current_user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: "ユーザー情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :investment_policy, :password, :password_confirmation)
  end
end
