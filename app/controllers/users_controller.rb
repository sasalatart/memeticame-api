class UsersController < ApplicationController
  def signup
    @user = User.new(user_params)

    if @user.save
      render json: { api_key: @user.token }
    else
      render status: 403, json: { message: @user.errors.full_messages }
    end
  end

  def login
    @user = User.find_by(phone_number: params[:phone_number])

    if @user.authenticate(params[:password])
      @user.generate_token
      render json: { api_key: @user.token }
    else
      render status: 403, json: { message: 'Invalid credentials' }
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
