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
#  category_id        :integer
#  name               :string
#

require 'test_helper'

class MemeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
