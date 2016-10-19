# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  title      :string
#  group      :boolean          default(FALSE)
#  admin_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chat < ApplicationRecord
  after_create :fcm_broadcast

  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'

  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users
  has_many :messages, dependent: :destroy
  has_many :chat_invitations, dependent: :destroy

  validates :title, presence: true
  validates :admin, presence: true

  def let_go(user)
    errors.add(:admin, 'can not leave chat until all users are removed.') if users.size > 1 && user == admin
    return false if errors.any?

    users.size > 1 ? remove_user(user, user, "Leaving #{title}") : destroy
  end

  def kick(user, current_user)
    errors.add(:admin, 'are the only ones who can kick people.') unless current_user == admin
    errors.add(:base, 'users can not kick themselves.') unless current_user != user
    errors.add(:base, 'user is not present in chat.') unless users.include?(user)
    return false if errors.any?

    remove_user(user, current_user, "Kicking #{user.name}")
  end

  def invite!(users)
    users.map { |user| ChatInvitation.create!(user: user, chat: self) }
  end

  def broadcast_invitations(chat_invitations)
    invited_user_ids = User.joins(:chat_invitations).where(chat_invitations: { id: chat_invitations.map(&:id) })
    return unless invited_user_ids.any?

    user_ids = invited_user_ids + users.map(&:id)
    fcm_broadcast(chat_invitations_options(chat_invitations, 'users_invited'), user_ids)
  end

  private

  def fcm_broadcast(options = { data: { chat: ChatSerializer.new(self, {}) }, collapse_key: 'chat_created' }, user_ids = users.map(&:id))
    fcm = FCM.new(Rails.application.secrets.fcm_key)
    registration_ids = FcmRegistration.where(user: user_ids).map(&:registration_token)
    fcm.send(registration_ids, options)
  end

  def remove_user(user, remover, message)
    fcm_broadcast(chat_user_options(user, 'user_kicked'))
    Message.create(content: message, chat: self, sender: remover)
    users.delete(user)
  end

  def chat_user_options(user, key)
    { data: { user: UserSerializer.new(user, {}),
              chat: ChatSerializer.new(self, {}) },
      collapse_key: key }
  end

  def chat_invitations_options(chat_invitations, key)
    { data: { chat_invitations: ActiveModel::Serializer::CollectionSerializer.new(chat_invitations, each_serializer: ChatInvitationSerializer) },
      collapse_key: key }
  end
end
