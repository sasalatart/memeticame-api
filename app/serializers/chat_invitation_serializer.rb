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

class ChatInvitationSerializer < ActiveModel::Serializer
  attributes :id, :chat_id, :chat_title, :created_at
  belongs_to :user
end
