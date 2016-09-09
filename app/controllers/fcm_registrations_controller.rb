class FcmRegistrationsController < ApplicationController
  def register
    if @current_user.fcm_register(params[:registration_token])
      render json: { message: 'FCM Token Updated' }
    else
      render json: { message: 'Unable to Update FCM Token' }
    end
  end
end
