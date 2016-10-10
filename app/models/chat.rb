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

  validates :title, presence: true
  validates :admin, presence: true

  def let_go(user)
    errors.add(:admin, 'can not leave chat until all users are removed.') if users.size > 1 && user == admin
    return false if errors.any?

    users.size > 1 ? remove_user(user, user, "Leaving #{@chat.title}") : destroy
  end

  def kick(user, current_user)
    errors.add(:admin, 'are the only ones who can kick people.') unless current_user == admin
    errors.add(:base, 'users can not kick themselves.') unless current_user != user
    errors.add(:base, 'user is not present in chat.') unless users.include?(user)
    return false if errors.any?

    remove_user(user, current_user, "Kicking #{user.name}")
  end

  private

  def fcm_broadcast(options = { data: ChatSerializer.new(self, {}), collapse_key: 'chat_created' })
    fcm = FCM.new(Rails.application.secrets.fcm_key)
    registration_ids = FcmRegistration.where(user: users.map(&:id)).map(&:registration_token)
    fcm.send(registration_ids, options)
  end

  def remove_user(user, remover, message)
    fcm_broadcast(data: { user_id: user.id, chat_id: id }, collapse_key: 'user_kicked')
    Message.create(content: message, chat: self, sender: remover)
    users.delete(user)
  end
end
