require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get auth_login_url
    assert_response :success
  end

  test "should get success" do
    get auth_success_url
    assert_response :success
  end

  test "should get fail" do
    get auth_fail_url
    assert_response :success
  end

end
