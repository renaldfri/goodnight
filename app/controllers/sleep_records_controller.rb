class SleepRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_user

  def index
    records = @user.sleep_records.order(created_at: :asc)
    
    render json: records
  end

  def create
    if @user.sleep_records.where(clock_out: nil).exists?
      render json: { error: 'User is already clocked in.' }, status: :unprocessable_entity
      return
    end

    sleep_record = @user.sleep_records.create(clock_in: Time.current)
    if sleep_record.persisted?
      render json: sleep_record, status: :created
    else
      render json: sleep_record.errors, status: :unprocessable_entity
    end
  end

  def update
    sleep_record = @user.sleep_records.where(clock_out: nil).last
    if sleep_record
      sleep_record.update(clock_out: Time.current)
      render json: sleep_record
    else
      render json: { error: 'No active sleep record found to clock out.' }, status: :unprocessable_entity
    end
  end

end 