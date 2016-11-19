# == Schema Information
#
# Table name: meme_tags
#
#  id         :integer          not null, primary key
#  meme_id    :integer
#  tag_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MemeTag < ApplicationRecord
  belongs_to :meme
  belongs_to :tag

  validates :meme, presence: true
  validates :tag, presence: true
end
