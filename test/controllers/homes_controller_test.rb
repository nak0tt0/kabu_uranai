require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get root_url # 👈 homes_top_url から root_url に変更
    assert_response :success
  end

  test "should get about" do
    get about_url # 👈 homes_about_url から about_url に変更
    assert_response :success
  end
end
