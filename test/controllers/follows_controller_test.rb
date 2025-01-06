require 'test_helper'

class FollowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Assuming you have a fixture for a user
    @following_user = users(:following_user) # Assuming you have a fixture for the user to be followed
  end

  test "should follow a user" do
    assert_difference('Follow.count', 1) do
      post follow_user_url(@user, target_user_id: @following_user.id) # Adjust the route as necessary
    end
    assert_response :created
    assert_includes @user.following.pluck(:id), @following_user.id # Ensure the user is now following
  end

  test "should not follow a user if already following" do
    @user.following_relationships.create(followed_id: @following_user.id) # Set up existing follow relationship

    assert_no_difference('Follow.count') do
      post follow_user_url(@user, target_user_id: @following_user.id) # Attempt to follow again
    end
    assert_response :unprocessable_entity
    assert_includes @response.body, 'Unable to follow the user.' # Check for error message
  end

  test "should unfollow a user" do
    @user.following_relationships.create(followed_id: @following_user.id) # Set up existing follow relationship

    assert_difference('Follow.count', -1) do
      delete unfollow_user_url(@user, target_user_id: @following_user.id) # Adjust the route as necessary
    end
    assert_response :ok
    assert_not_includes @user.following.pluck(:id), @following_user.id # Ensure the user is no longer following
  end

  test "should not unfollow a user if not following" do
    assert_no_difference('Follow.count') do
      delete unfollow_user_url(@user, target_user_id: @following_user.id) # Attempt to unfollow without following
    end
    assert_response :not_found
    assert_includes @response.body, 'You are not following this user.' # Check for error message
  end
end 