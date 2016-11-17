# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  channel_id :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ApplicationRecord
  belongs_to :channel

  has_many :memes, dependent: :destroy

  validates :channel, presence: true
  validates :name, presence: true
end
