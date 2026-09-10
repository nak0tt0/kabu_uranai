class NotificationsController < ApplicationController
  # authenticate_user! から ApplicationController 内の認証フィルター等に修正
  # （必要に応じて before_action のメソッド名をプロジェクトの共通メソッドに合わせてください）
  
  def index
    @notifications = current_user.notifications.recent
  end

  def read_all
    current_user.notifications.unread.update_all(read_status: true)
    redirect_to notifications_path, notice: "すべての通知を既読にしました。"
  end
end
