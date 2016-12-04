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

  def search
    if params[:tags] && params[:tags].values[0].present?
      @memes = Meme.includes(:tags)
                   .where(tags: { text: params[:tags].values.map(&:downcase) })
    end

    name = params[:name]
    @memes = (@memes || Meme.all).where('name LIKE ?', "%#{name}%") if name

    render json: @memes.distinct, status: :ok
  end

  private

  def meme_params
    params.permit(:category_id, :name)
  end
end
