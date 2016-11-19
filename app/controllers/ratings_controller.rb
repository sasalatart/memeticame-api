class RatingsController < ApplicationController
  before_action :set_meme, only: [:create, :my_rating]

  def create
    @rating = Rating.find_or_initialize_by(meme: @meme, user: @current_user)
    @rating.value = params[:value]

    if @rating.save
      render json: @rating.meme, status: :ok
    else
      render json: { message: @rating.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def my_rating
    @rating = @meme.ratings.find_by(user: @current_user)

    render json: { value: @rating.try(:value) || 0 }, status: :ok
  end

  private

  def set_meme
    @meme = Meme.find(params[:meme_id])
  end
end
