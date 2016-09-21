# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  phone_number    :string
#  password_digest :string
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  after_create :fcm_broadcast

  alias_attribute :phone, :phone_number

  has_many :chat_users, dependent: :destroy
  has_many :chats, through: :chat_users

  has_one :fcm_registration

  after_create :generate_token

  validates :name, presence: true

  validates :phone_number, presence: true,
                           uniqueness: true

  has_secure_password

  def generate_token
    token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
    update(token: token)
  end

  def fcm_register(registration_token)
    return false if registration_token.blank?

    if fcm_registration
      fcm_registration.update(registration_token: registration_token)
    else
      build_fcm_registration(registration_token: registration_token)
      save
    end
  end

  private

  def fcm_broadcast
    fcm = FCM.new(Rails.application.secrets.fcm_key)
    registration_ids = FcmRegistration.all.map(&:registration_token)

    options = {
      data: UserSerializer.new(self, {}),
      collapse_key: 'user_created'
    }

    fcm.send(registration_ids, options)
  end
end
