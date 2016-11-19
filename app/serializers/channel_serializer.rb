# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :name, :rating, :created_at

  belongs_to :owner

  has_many :categories

  def rating
    Rating.where(meme: object.memes).average(:value) || 0
  end
end
