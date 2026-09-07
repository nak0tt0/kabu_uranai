class ApplicationController < ActionController::Base
  # Rails 8 標準のブラウザ制限・キャッシュ制御設定
  allow_browser versions: :modern
  stale_when_importmap_changes

  # 認証・セッションヘルパーの追加
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_user_login
    unless logged_in?
      flash[:alert] = "ログインが必要です"
      redirect_to login_path
    end
  end
end
