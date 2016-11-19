class MemesController < ApplicationController
  def create
    @meme = Meme.new(meme_params)
    @meme.owner = @current_user
    @meme.build_base64_image(params)
    @meme.build_tags(params[:tags].values)

    if @meme.save
      render json: @meme, status: :ok
    else
      render json: { message: @meme.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def meme_params
    params.permit(:category_id, :name)
  end
end
