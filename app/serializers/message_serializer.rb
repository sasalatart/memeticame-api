class MessageSerializer < ActiveModel::Serializer
  attributes :id, :sender_phone, :chat_id, :content, :created_at
end
