require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @valid_attributes = { name: 'Test User'}
    @invalid_attributes = { name: ''}
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: @valid_attributes }
    end
    assert_response :created
  end

  test "should not create user with invalid params" do
    assert_no_difference('User.count') do
      post users_url, params: { user: @invalid_attributes }
    end
    assert_response :unprocessable_entity
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { name: 'Updated User' } }
    assert_response :success
    @user.reload
    assert_equal 'Updated User', @user.name
  end

  test "should not update user with invalid params" do
    patch user_url(@user), params: { user: @invalid_attributes }
    assert_response :unprocessable_entity
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_response :no_content
  end
end