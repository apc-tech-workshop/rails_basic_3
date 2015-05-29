require 'test_helper'

class HogesControllerTest < ActionController::TestCase
  setup do
    @hoge = hoges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hoges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hoge" do
    assert_difference('Hoge.count') do
      post :create, hoge: { name: @hoge.name }
    end

    assert_redirected_to hoge_path(assigns(:hoge))
  end

  test "should show hoge" do
    get :show, id: @hoge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hoge
    assert_response :success
  end

  test "should update hoge" do
    patch :update, id: @hoge, hoge: { name: @hoge.name }
    assert_redirected_to hoge_path(assigns(:hoge))
  end

  test "should destroy hoge" do
    assert_difference('Hoge.count', -1) do
      delete :destroy, id: @hoge
    end

    assert_redirected_to hoges_path
  end
end
