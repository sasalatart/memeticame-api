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

class Channel < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  has_many :memes, through: :categories
  has_many :categories, dependent: :destroy

  validates :owner, presence: true
  validates :name, presence: true

  def add_categories(categories)
    errors.add(:base, 'should have at least one category') if categories.empty?
    return if errors.any?

    categories.each { |category_name| self.categories << Category.new(name: category_name) }
  end
end
