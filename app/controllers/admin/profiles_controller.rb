class Admin::ProfilesController < Admin::BaseController
  before_action :set_admin

  def edit
  end

  def update
    # パスワード入力がない場合はパスワード変更を行わない設定
    update_params = admin_params
    if update_params[:password].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end

    if @admin.update(update_params)
      flash[:notice] = "管理者プロフィールを更新しました。"
      redirect_to admin_dashboard_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_admin
    @admin = current_admin
  end

  def admin_params
    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end
end
