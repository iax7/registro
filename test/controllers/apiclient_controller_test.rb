require 'test_helper'

class ApiclientControllerTest < ActionController::TestCase
  test "should get assistance" do
    get :assistance
    assert_response :success
  end

  test "should get food" do
    get :food
    assert_response :success
  end

end
