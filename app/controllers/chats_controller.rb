class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :leave, :kick, :invite, :invitations]
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
    invitations = []
    params[:users] ||= {}

    ActiveRecord::Base.transaction do
      invitations = @chat.set_users!(params[:group], params[:admin], params[:users].values)
      @chat.save!
    end

    @chat.broadcast_invitations(invitations)
    render json: @chat, status: :created

  rescue ActiveRecord::RecordInvalid => exception
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  def leave
    if @chat.let_go(@current_user)
      render json: @chat, status: :ok
    else
      render json: { message: @chat.errors.full_messages.join(', ') }, status: :bad_request
    end
  end

  def kick
    if @chat.kick(@user, @current_user)
      render json: @chat, status: :ok
    else
      render json: { message: @chat.errors.full_messages.join(', ') }, status: :bad_request
    end
  end

  def invitations
    render json: @chat.chat_invitations, status: :ok
  end

  def invite
    ActiveRecord::Base.transaction do
      invitations = @chat.invite!(params[:users].values)
      @chat.broadcast_invitations(invitations)
      render json: invitations, status: :ok
    end

  rescue ActiveRecord::RecordInvalid => exception
    render json: { message: exception.message }, status: :unprocessable_entity
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
