class ChatInvitationsController < ApplicationController
  before_action :set_chat_invitation, only: [:accept, :reject]

  def index
    render json: @current_user.chat_invitations, status: :ok
  end

  def accept
    if @chat_invitation.accept(@current_user)
      render json: @chat_invitation, status: :ok
    else
      render json: { message: @chat_invitation.errors.full_messages.join(', ') }, status: :bad_request
    end
  end

  def reject
    if @chat_invitation.reject(@current_user)
      render json: @chat_invitation, status: :ok
    else
      render json: { message: @chat_invitation.errors.full_messages.join(', ') }, status: :bad_request
    end
  end

  private

  def set_chat_invitation
    @chat_invitation = ChatInvitation.find(params[:id])
  end
end
