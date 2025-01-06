class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_user, only: [:show, :update, :destroy, :clock_in, :clock_out, :sleep_records]

  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end

  def clock_in
    if @user.sleep_records.where(clock_out: nil).exists?
      render json: { error: 'User is already clocked in.' }, status: :unprocessable_entity
      return
    end

    @sleep_record = @user.sleep_records.create(clock_in: Time.current)
    if @sleep_record.persisted?
      render json: @sleep_record, status: :created
    else
      render json: @sleep_record.errors, status: :unprocessable_entity
    end
  end

  def clock_out
    @sleep_record = @user.sleep_records.last
    if @sleep_record && @sleep_record.clock_out.nil?
      @sleep_record.update(clock_out: Time.current)
      render json: @sleep_record
    else
      render json: { error: 'No active sleep record found to clock out.' }, status: :unprocessable_entity
    end
  end

  def sleep_records
    @sleep_records = @user.sleep_records.order(created_at: :asc)
    
    render json: @sleep_records
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      render json: { error: 'User not found' }, status: :not_found
      return
    end
  end
end