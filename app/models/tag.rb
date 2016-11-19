# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
  before_create :downcase

  has_many :meme_tags, dependent: :destroy
  has_many :memes, through: :meme_tags

  validates :text, presence: true

  private

  def downcase
    text.downcase!
  end
end
