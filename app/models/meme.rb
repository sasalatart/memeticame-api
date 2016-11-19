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

class Meme < ApplicationRecord
  include Imageable

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :category

  has_many :meme_tags, dependent: :destroy
  has_many :tags, through: :meme_tags

  validates :owner, presence: true
  validates :category, presence: true
  validates :name, presence: true

  validates :rating, presence: true,
                     numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  def build_tags(meme_params)
    return unless meme_params[:tags].present?

    meme_params[:tags].values.each do |tag_text|
      tags << (Tag.find_by(text: tag_text) || Tag.new(text: tag_text))
    end
  end
end
