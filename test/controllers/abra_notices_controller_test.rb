require 'test_helper'

class AbraNoticesControllerTest < ActionController::TestCase
  setup do
    @abra_notice = abra_notices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:abra_notices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create abra_notice" do
    assert_difference('AbraNotice.count') do
      post :create, abra_notice: { anc_id: @abra_notice.anc_id, hearing_date: @abra_notice.hearing_date, license_class_id: @abra_notice.license_class_id, petition_date: @abra_notice.petition_date, posting_date: @abra_notice.posting_date, protest_date: @abra_notice.protest_date }
    end

    assert_redirected_to abra_notice_path(assigns(:abra_notice))
  end

  test "should show abra_notice" do
    get :show, id: @abra_notice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @abra_notice
    assert_response :success
  end

  test "should update abra_notice" do
    patch :update, id: @abra_notice, abra_notice: { anc_id: @abra_notice.anc_id, hearing_date: @abra_notice.hearing_date, license_class_id: @abra_notice.license_class_id, petition_date: @abra_notice.petition_date, posting_date: @abra_notice.posting_date, protest_date: @abra_notice.protest_date }
    assert_redirected_to abra_notice_path(assigns(:abra_notice))
  end

  test "should destroy abra_notice" do
    assert_difference('AbraNotice.count', -1) do
      delete :destroy, id: @abra_notice
    end

    assert_redirected_to abra_notices_path
  end
end
