# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  sender_id  :integer
#  chat_id    :integer
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
  after_create :fcm_broadcast

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :chat

  validates :sender, presence: true
  validates :chat, presence: true
  validates :content, presence: true

  def sender_phone
    sender.phone_number
  end

  private

  def fcm_broadcast
    fcm = FCM.new(Rails.application.secrets.fcm_key)
    registration_ids = FcmRegistration.where(user: chat.users).map(&:registration_token)

    options = {
      data: { id: id, chat_id: chat.id, sender_phone: sender_phone, message: content },
      collapse_key: 'updated_score'
    }
    response = fcm.send(registration_ids, options)
  end
end
