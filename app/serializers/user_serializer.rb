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

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone_number, :created_at
end
