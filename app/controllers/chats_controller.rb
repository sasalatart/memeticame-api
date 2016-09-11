class ChatsController < ApplicationController
  before_action :set_chat, only: [:leave]

  def index
    render json: @current_user.chats, status: :ok
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.group = params[:group] == 'true'
    @chat.admin = User.find_by(phone_number: params[:admin])
    @chat.users = User.where(phone_number: (params[:users].values << params[:admin]))

    if @chat.save
      render json: @chat, status: :created
    else
      render json: { message: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def leave
    if @chat.remove_user(@current_user)
      render json: { message: 'User successfully removed from chat' }, status: :ok
    else
      render json: { message: 'User could not be removed from chat' }, status: :bad_request
    end
  end

  private

  def chat_params
    params.permit(:title)
  end

  def set_chat
    @chat = Chat.find(params[:id])
  end
end
