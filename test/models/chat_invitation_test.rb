# == Schema Information
#
# Table name: chat_invitations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  chat_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ChatInvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
