require 'test_helper'

class WardControllerTest < ActionController::TestCase
  setup do
    @ward = wards(:one)
  end

  test "should show location" do
    get :show, id: @ward
    assert_response :success
  end
end
