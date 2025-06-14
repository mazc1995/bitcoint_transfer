class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do |exception|
    render json: { error: 'Forbidden' }, status: :forbidden
  end

  private

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end

  def current_user
    return @current_user if defined?(@current_user)
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    if token
      begin
        decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
        @current_user = User.find_by(id: decoded['user_id'])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        @current_user = nil
      end
    end
    @current_user
  end
end
