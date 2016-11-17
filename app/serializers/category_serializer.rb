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

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :channel_id, :name, :created_at

  has_many :memes
end
