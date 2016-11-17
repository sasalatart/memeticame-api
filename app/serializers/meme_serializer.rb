# == Schema Information
#
# Table name: memes
#
#  id                 :integer          not null, primary key
#  owner_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  rating             :decimal(, )      default(0.0)
#  category_id        :integer
#  name               :string
#

class MemeSerializer < ActiveModel::Serializer
  attributes :id, :category_id, :name, :thumb_url, :original_url, :rating, :created_at

  belongs_to :owner

  def thumb_url
    object.image.url(:thumb)
  end

  def original_url
    object.image.url
  end
end
