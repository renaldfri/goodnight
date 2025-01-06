class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      render json: { error: 'User not found' }, status: :not_found
      return
    end
  end
end
