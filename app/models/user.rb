class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :videos

  validates :password, length: {minimum: 6}
  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true
end