require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url # 👈 top_index_url から root_url に変更
    assert_response :success
  end
end
