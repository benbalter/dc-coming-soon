require 'test_helper'

class PostingsControllerTest < ActionController::TestCase
  setup do
    @posting = postings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:postings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create posting" do
    assert_difference('Posting.count') do
      post :create, posting: { abra_bulletin_id: @posting.abra_bulletin_id, applicant: @posting.applicant, body: @posting.body, details: @posting.details, hearing_date: @posting.hearing_date, licensee_id: @posting.licensee_id, number: @posting.number, pdf_page: @posting.pdf_page, posting_date: @posting.posting_date, raw_address: @posting.raw_address, slug: @posting.slug, status: @posting.status, type: @posting.type }
    end

    assert_redirected_to posting_path(assigns(:posting))
  end

  test "should show posting" do
    get :show, id: @posting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @posting
    assert_response :success
  end

  test "should update posting" do
    patch :update, id: @posting, posting: { abra_bulletin_id: @posting.abra_bulletin_id, applicant: @posting.applicant, body: @posting.body, details: @posting.details, hearing_date: @posting.hearing_date, licensee_id: @posting.licensee_id, number: @posting.number, pdf_page: @posting.pdf_page, posting_date: @posting.posting_date, raw_address: @posting.raw_address, slug: @posting.slug, status: @posting.status, type: @posting.type }
    assert_redirected_to posting_path(assigns(:posting))
  end

  test "should destroy posting" do
    assert_difference('Posting.count', -1) do
      delete :destroy, id: @posting
    end

    assert_redirected_to postings_path
  end
end
