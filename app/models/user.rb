class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :videos
  has_many :reviews

  validates :password, length: {minimum: 6}
  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true
end