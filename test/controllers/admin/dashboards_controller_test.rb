require "test_helper"

class Admin::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_dashboard_url
    # 未ログイン時はログイン画面へリダイレクトされるか、またはレスポンス確認
    assert_response :redirect
  end
end
