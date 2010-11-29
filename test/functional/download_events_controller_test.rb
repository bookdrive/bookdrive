require 'test_helper'

class DownloadEventsControllerTest < ActionController::TestCase
  setup do
    @download_event = download_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:download_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create download_event" do
    assert_difference('DownloadEvent.count') do
      post :create, :download_event => @download_event.attributes
    end

    assert_redirected_to download_event_path(assigns(:download_event))
  end

  test "should show download_event" do
    get :show, :id => @download_event.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @download_event.to_param
    assert_response :success
  end

  test "should update download_event" do
    put :update, :id => @download_event.to_param, :download_event => @download_event.attributes
    assert_redirected_to download_event_path(assigns(:download_event))
  end

  test "should destroy download_event" do
    assert_difference('DownloadEvent.count', -1) do
      delete :destroy, :id => @download_event.to_param
    end

    assert_redirected_to download_events_path
  end
end
