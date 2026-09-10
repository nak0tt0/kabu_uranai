class Admin::DashboardsController < Admin::BaseController
  def show
    # 総登録ユーザー数
    @total_users_count = User.count

    # アクティブユーザー数（銘柄を1件以上登録しているユーザー）
    @active_users_count = User.joins(:stocks).distinct.count

    # 総登録銘柄数
    @total_stocks_count = Stock.count
  end
end
