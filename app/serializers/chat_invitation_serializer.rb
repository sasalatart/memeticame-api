class ChatInvitationSerializer < ActiveModel::Serializer
  attributes :id, :chat_id, :chat_title, :created_at
  belongs_to :user
end
