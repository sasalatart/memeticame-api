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

require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
