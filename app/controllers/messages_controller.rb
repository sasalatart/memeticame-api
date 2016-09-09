class MessagesController < ApplicationController
  before_action :set_chat

  def index
    render json: @chat.messages
  end

  def create
    @message = Message.new(message_params)
    @message.sender = @current_user

    if @message.save
      render json: @message
    else
      render json: { message: @message.errors.full_messages }
    end
  end

  private

  def set_chat
    @chat = Chat.find_by(id: params[:chat_id])
  end

  def message_params
    params.permit(:chat_id, :content)
  end
end
