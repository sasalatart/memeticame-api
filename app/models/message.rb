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

  has_attached_file :attachment,
                    styles: ->(a) { a.instance.set_style },
                    hash_secret: Rails.application.secrets.secret_key_base,
                    dependent: :destroy

  validates :sender, presence: true
  validates :chat, presence: true
  validates :content, presence: true

  validate :sender_belongs_to_chat

  do_not_validate_attachment_file_type :attachment

  delegate :phone, to: :sender, prefix: true

  def attachment_link
    url = if attachment_content_type =~ /\A(image\/.*|video\/.*|audio\/.*)\z/
            attachment.url(:optimized)
          else
            attachment? ? attachment.url : nil
          end

    { name: attachment_file_name, mime_type: attachment_content_type, url: url }
  end

  def build_base64_attachment(attachment_params)
    base64 = "data:#{attachment_params[:mime_type]};base64,#{attachment_params[:base64]}"
    attachment = Paperclip.io_adapters.for(base64)
    attachment.content_type = attachment_params[:mime_type]
    attachment.original_filename = attachment_params[:name]
    self.attachment = attachment
  end

  def set_style
    if attachment_content_type =~ /image/
      { optimized: '640x480>' }
    elsif attachment_content_type =~ /video/
      { optimized: { geometry: '640x360#', format: 'mp4', processors: [:transcoder] } }
    elsif attachment_content_type =~ /audio/ && !(attachment_content_type =~ /memeaudio/)
      { optimized: { format: 'mp3', processors: [:transcoder] } }
    else
      {}
    end
  end

  private

  def fcm_broadcast(options = { data: MessageSerializer.new(self, {}), collapse_key: 'message_created' })
    fcm = FCM.new(Rails.application.secrets.fcm_key)
    registration_ids = FcmRegistration.where(user: chat.users).map(&:registration_token)
    fcm.send(registration_ids, options)
  end

  def sender_belongs_to_chat
    errors.add(:sender, 'must belong to chat') unless chat.users.include?(sender)
  end
end
