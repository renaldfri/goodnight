require 'test_helper'

class SleepRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.sleep_records.destroy_all
  end

  test "should get index of clocked-in records" do
    @user.sleep_records.create(clock_in: Time.current, clock_out: nil)
    @user.sleep_records.create(clock_in: Time.current - 1.hour, clock_out: nil)

    get sleep_records_user_url(@user)
    assert_response :success

    sleep_records = JSON.parse(@response.body)
    assert_equal 2, sleep_records.size
    assert_nil sleep_records[0]['clock_out']
    assert_nil sleep_records[1]['clock_out']
  end

  test "should clock in" do
    assert_difference('SleepRecord.count', 1) do
      post clock_in_user_url(@user)
    end
    assert_response :created
  end

  test "should not clock in if already clocked in" do
    @user.sleep_records.create(clock_in: Time.current, clock_out: nil)

    post clock_in_user_url(@user)
    assert_response :unprocessable_entity
    assert_includes @response.body, 'User is already clocked in.'
  end

  test "should clock out" do
    sleep_record = @user.sleep_records.create(clock_in: Time.current, clock_out: nil)

    post clock_out_user_url(@user)
    assert_response :success
    sleep_record.reload
    assert_not_nil sleep_record.clock_out
  end

  test "should not clock out if no active record" do
    post clock_out_user_url(@user)
    assert_response :unprocessable_entity
    assert_includes @response.body, 'No active sleep record found to clock out.'
  end

  test "should get following sleep records sorted by duration" do
    following_user = users(:following_user)
    @user.following_relationships.create(followed_id: following_user.id)

    following_user.sleep_records.create(clock_in: Time.current - 1.hour, clock_out: 1.day.ago + 5.hours)

    get following_sleep_records_user_url(@user)
    assert_response :success

    sleep_records = JSON.parse(@response.body)
    assert_equal 1, sleep_records.size
    assert_equal following_user.id, sleep_records[0]['user_id']
  end
end