# == Schema Information
#
# Table name: chat_invitations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  chat_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChatInvitation < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :user, presence: true

  validates :chat, presence: true,
                   uniqueness: { scope: :user }

  delegate :title, to: :chat, prefix: true

  def accept(accepting_user)
    errors.add(:user, 'is not the invited user') if accepting_user != user
    return false if errors.any?

    chat.users << accepting_user
    Message.create(chat: chat, sender: chat.admin, content: "#{accepting_user.name} just accepted the invitation")
    fcm_broadcast('chat_invitation_accepted')
    destroy
  end

  def reject(rejecting_user)
    errors.add(:user, 'is not the invited user') if rejecting_user != user
    return false if errors.any?

    Message.create(chat: chat, sender: chat.admin, content: "#{rejecting_user.name} just rejected the invitation")
    fcm_broadcast('chat_invitation_rejected')
    destroy
  end

  private

  def fcm_broadcast(key)
    options = { data: { chat_invitation: ChatInvitationSerializer.new(self, {}), chat: ChatSerializer.new(chat, {}) }, collapse_key: key }
    fcm = FCM.new(Rails.application.secrets.fcm_key)
    registration_ids = FcmRegistration.where(user: chat.users.map(&:id)).map(&:registration_token)
    fcm.send(registration_ids, options)
  end
end
