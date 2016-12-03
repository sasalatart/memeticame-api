class EmotionsController < ApplicationController
  def recognize
    file_name = EmotionsService.to_dropbox(params[:base64], params[:mime_type])
    emotions_response = EmotionsService.query_emotions(file_name)

    render json: emotions_response.body, status: :ok
  end
end
