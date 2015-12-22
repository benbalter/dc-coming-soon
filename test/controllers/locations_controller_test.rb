require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  setup do
    @location = locations(:white_house)
  end

  test "should show location" do
    get :show, id: @location
    assert_response :success
  end
end
