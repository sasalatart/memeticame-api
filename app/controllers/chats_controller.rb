class ChatsController < ApplicationController
  def index
    render json: @current_user.chats
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.group = params[:group] == 'true'
    @chat.admin = User.find_by(phone_number: params[:admin])
    @chat.users = User.where(phone_number: params[:users].values)

    if @chat.save
      render json: @chat
    else
      render json: { message: @chat.errors.full_messages }
    end
  end

  private

  def chat_params
    params.permit(:title)
  end
end
