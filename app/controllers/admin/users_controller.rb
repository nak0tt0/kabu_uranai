class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.order(created_at: :desc)
  end

  def show
  end

  def destroy
    @user.destroy
    flash[:notice] = "ユーザー「#{@user.email}」を強制退会処理（削除）しました。"
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
