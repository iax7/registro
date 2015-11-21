require 'test_helper'

class BaseApiControllerTest < ActionController::TestCase
  test "should get assist" do
    get :assist
    assert_response :success
  end

  test "should get food" do
    get :food
    assert_response :success
  end

end
