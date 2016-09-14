# == Schema Information
#
# Table name: messages
#
#  id                      :integer          not null, primary key
#  sender_id               :integer
#  chat_id                 :integer
#  content                 :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
