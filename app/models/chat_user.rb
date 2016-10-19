# == Schema Information
#
# Table name: chat_users
#
#  id         :integer          not null, primary key
#  chat_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChatUser < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :user, presence: true,
                   uniqueness: { scope: :chat }

  validates :chat, presence: true
end
