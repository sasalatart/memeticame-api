class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :leave, :kick, :add_users]
  before_action :set_user, only: [:kick]

  def index
    render json: @current_user.chats, status: :ok
  end

  def show
    if @chat.users.include?(@current_user)
      render json: @chat, status: :ok
    else
      render json: { message: 'Not allowed' }, status: :bad_request
    end
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
    if @chat.let_go(@current_user)
      render json: { message: 'User successfully removed from chat' }, status: :ok
    else
      render json: { message: @chat.errors.full_messages.join(', ') }, status: :bad_request
    end
  end

  def kick
    if @chat.kick(@user, @current_user)
      render json: { message: 'User successfully kicked from chat' }, status: :ok
    else
      render json: { message: @chat.errors.full_messages.join(', ') }, status: :bad_request
    end
  end

  def add_users
    if @chat.add_users(User.where(phone_number: params[:users].values), @current_user)
      render json: @chat, status: :ok
    else
      render json: { message: @chat.errors.full_messages.join(', ') }, status: :bad_request
    end
  end

  private

  def chat_params
    params.permit(:title)
  end

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
