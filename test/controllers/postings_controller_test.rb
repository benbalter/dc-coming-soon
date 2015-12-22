require 'test_helper'

class PostingsControllerTest < ActionController::TestCase

  setup do
    stub_request(:get, "http://citizenatlas.dc.gov/newwebservices/locationverifier.asmx/findLocation?str=1600%20Pennslyvania%20ave%20nw").
      to_return(:status => 200, :body => fixture("white-house.xml"))
  end

  test "should get index" do
    get :index, address: "1600 Pennslyvania ave nw"
    assert_response :success
    assert_not_nil assigns(:postings)
  end
end
