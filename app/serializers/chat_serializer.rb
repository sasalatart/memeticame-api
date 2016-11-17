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

class ChatSerializer < ActiveModel::Serializer
  attributes :id, :title, :group, :created_at

  belongs_to :admin

  has_many :users
  has_many :messages
end
