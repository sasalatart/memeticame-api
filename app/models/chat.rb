# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  title      :string
#  group      :boolean
#  admin_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chat < ApplicationRecord
  after_create :add_admin

  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'

  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users

  validates :title, presence: true
  validates :admin, presence: true

  def add_admin
    ChatUser.create(chat: self, user: admin)
  end
end
