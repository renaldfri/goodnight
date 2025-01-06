class FollowsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_user
  before_action :set_target_user

  def create
    follow_relationship = Follow.new(follower_id: @user.id, followed_id: @target_user.id)

    if follow_relationship.save
      render json: { message: 'Successfully followed the user.' }, status: :created
    else
      render json: { error: 'Unable to follow the user.' }, status: :unprocessable_entity
    end
  end

  def delete
    follow_relationship = Follow.find_by(follower_id: @user.id, followed_id: @target_user.id)

    if follow_relationship
      follow_relationship.destroy
      render json: { message: 'Successfully unfollowed the user.' }, status: :ok
    else
      render json: { error: 'You are not following this user.' }, status: :not_found
    end
  end

  private

  def set_target_user
    @target_user = User.find_by(id: params[:target_user_id])
    unless @target_user
      render json: { error: 'Target user not found' }, status: :not_found
      return
    end
  end
end 