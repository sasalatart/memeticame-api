# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  meme_id    :integer
#  user_id    :integer
#  value      :decimal(, )      default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Rating < ApplicationRecord
  belongs_to :meme
  belongs_to :user

  validates :meme, presence: true,
                   uniqueness: { scope: :user }

  validates :user, presence: true

  validates :value, presence: true,
                    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
end
