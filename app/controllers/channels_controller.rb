class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show]

  def index
    render json: Channel.all, status: :ok
  end

  def show
    render json: @channel, status: :ok
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  end
end
