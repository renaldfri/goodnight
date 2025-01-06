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

  test "should clock in" do
    assert_difference('SleepRecord.count', 1) do
      post clock_in_user_url(@user)
    end
    assert_response :created
  end

  test "should clock out" do
    sleep_record = @user.sleep_records.create(clock_in: Time.current)

    sleep_record.update(clock_out: nil)
    post clock_out_user_url(@user)
    assert_response :success
    sleep_record.reload
    assert_not_nil sleep_record.clock_out
  end

  test "should not clock out if no active record" do
    @user.sleep_records.destroy_all

    post clock_out_user_url(@user)
    assert_response :unprocessable_entity
    assert_includes @response.body, 'No active sleep record found to clock out.'
  end

  test "should not clock in if already clocked in" do
    sleep_record = @user.sleep_records.create(clock_in: Time.current)

    post clock_in_user_url(@user)
    assert_response :unprocessable_entity
  end

  test "should get sleep records ordered by created_at" do
    @user.sleep_records.destroy_all

    @user.sleep_records.create(clock_in: Time.current - 1.hour, clock_out: Time.current)
    @user.sleep_records.create(clock_in: Time.current - 2.hours, clock_out: Time.current)
    @user.sleep_records.create(clock_in: Time.current - 3.hours, clock_out: Time.current)

    get sleep_records_user_url(@user)
    assert_response :success

    sleep_records = JSON.parse(@response.body)

    assert_equal 3, sleep_records.size
  end
end