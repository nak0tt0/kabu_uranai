class Admin::SessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by(email: params[:session][:email]&.downcase)
    if admin&.authenticate(params[:session][:password])
      session[:admin_id] = admin.id
      redirect_to admin_dashboard_path, notice: "管理者としてログインしました。"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to admin_login_path, notice: "管理者からログアウトしました。"
  end
end
