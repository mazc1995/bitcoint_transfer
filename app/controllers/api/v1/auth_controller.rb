class Api::V1::AuthController < ApplicationController
  # POST /api/v1/register
  def register
    result = Auth::RegisterUser.new(user_params).call
    if result.success?
      render json: { user: result.user_response, token: result.token }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/login
  def login
    result = Auth::LoginUser.new(user_params).call
    if result.success?
      render json: { user: result.user_response, token: result.token }, status: :ok
    else
      render json: { error: result.error }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :balance_usd, :balance_btc)
  end
end 