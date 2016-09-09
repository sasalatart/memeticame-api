# == Schema Information
#
# Table name: fcm_registrations
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  registration_token :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class FcmRegistrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
