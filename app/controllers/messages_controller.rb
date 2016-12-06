class MessagesController < ApplicationController
  before_action :set_chat

  def index
    if @chat.users.include?(@current_user)
      render json: @chat.messages, status: :ok
    else
      render json: { message: 'Not allowed' }, status: :forbidden
    end
  end

  def create
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.sender = @current_user
    @message.build_base64_attachment(params[:attachment]) if params[:attachment]

    if @message.save
      render json: @message, status: :created
    else
      render json: { message: @message.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def message_params
    params.permit(:content)
  end
end
