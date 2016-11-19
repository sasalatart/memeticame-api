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

require 'test_helper'

class MemeTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
