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
end
