class PlainMemesController < ApplicationController
  def index
    @plain_memes = PlainMeme.all.map do |plain_meme|
      { thumb: plain_meme.image.url(:thumb), original: plain_meme.image.url }
    end

    render json: { plain_memes: @plain_memes }, status: :ok
  end
end
