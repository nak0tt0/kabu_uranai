class Admin::BaseController < ApplicationController
  before_action :require_admin_login

  # ビュー(ERB)側でも current_admin, admin_logged_in? を使用可能にする
  helper_method :current_admin, :admin_logged_in?

  private

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end

  def admin_logged_in?
    current_admin.present?
  end

  def require_admin_login
    unless admin_logged_in?
      flash[:alert] = "管理者権限が必要です。ログインしてください。"
      redirect_to admin_login_path
    end
  end
end
