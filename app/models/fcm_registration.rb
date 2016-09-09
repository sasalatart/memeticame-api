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

class FcmRegistration < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :registration_token, presence: true
end
