require 'test_helper'

class AncControllerTest < ActionController::TestCase
  setup do
    @anc = ancs(:"1A")
  end

  test "should get anc" do
    get :show, id: @anc
    assert_response :success
  end
end
