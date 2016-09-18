# == Schema Information
#
# Table name: messages
#
#  id                      :integer          not null, primary key
#  sender_id               :integer
#  chat_id                 :integer
#  content                 :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#

class Message < ApplicationRecord
  after_create :fcm_broadcast

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :chat

  has_attached_file :attachment

  validates :sender, presence: true
  validates :chat, presence: true
  validates :content, presence: true

  validates_attachment_content_type :attachment, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  delegate :phone, to: :sender, prefix: true

  def attachment_link
    url = attachment? ? attachment.url : nil
    { name: attachment_file_name, mime_type: attachment_content_type, url: url }
  end

  def build_base64_attachment(attachment_params)
    base64 = "data:#{attachment_params[:mime_type]};base64,#{attachment_params[:base64]}"
    attachment = Paperclip.io_adapters.for(base64)
    attachment.original_filename = attachment_params[:name]
    self.attachment = attachment
  end

  private

  def fcm_broadcast
    fcm = FCM.new(Rails.application.secrets.fcm_key)
    registration_ids = FcmRegistration.where(user: chat.users).map(&:registration_token)

    options = {
      data: MessageSerializer.new(self, {}),
      collapse_key: 'message_created'
    }

    fcm.send(registration_ids, options)
  end
end
