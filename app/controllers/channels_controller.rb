class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show]

  def index
    render json: Channel.all, status: :ok
  end

  def show
    render json: @channel, status: :ok
  end

  def create
    @channel = Channel.new(channel_params)
    @channel.owner = @current_user
    @channel.add_categories(params[:categories].values)

    if @channel.save
      render json: @channel, status: :created
    else
      render json: { message: @channel.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def channel_params
    params.permit(:name)
  end

  def set_channel
    @channel = Channel.find(params[:id])
  end
end
