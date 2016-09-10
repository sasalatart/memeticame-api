class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:signup, :login]

  def index
    render json: User.all, status: :ok
  end

  def signup
    @user = User.new(user_params)

    if @user.save
      render json: { api_key: @user.token }, status: :created
    else
      render json: { message: @user.errors.full_messages }, status: :not_acceptable
    end
  end

  def login
    @user = User.find_by(phone_number: params[:phone_number])

    if @user&.authenticate(params[:password])
      @user.generate_token
      render json: { api_key: @user.token }, status: :ok
    else
      render json: { message: 'Invalid credentials' }, status: :forbidden
    end
  end

  def logout
    if @current_user.fcm_registration.destroy
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render json: { message: 'Could not logout' }, status: :not_acceptable
    end
  end

  private

  def user_params
    params.permit(:name,
                  :phone_number,
                  :password,
                  :password_confirmation)
  end
end
