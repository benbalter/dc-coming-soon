require 'test_helper'

class AbraNoticesControllerTest < ActionController::TestCase
  setup do
    @abra_notice = postings(:abra_notice)
  end

  test "should show abra_notice" do
    get :show, id: @abra_notice
    assert_response :success
  end
end
