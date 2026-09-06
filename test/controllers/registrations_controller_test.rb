require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should get create" do
    assert_difference("User.count", 1) do
      post signup_url, params: {
        user: {
          name: "Test User",
          email: "test_create@example.com",
          password: "password",
          password_confirmation: "password",
          investment_policy: "方針"
        }
      }
    end
    assert_redirected_to mypage_url
  end
end
