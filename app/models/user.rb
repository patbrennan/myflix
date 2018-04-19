class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :videos
  has_many :reviews
  has_many :q_items, -> { order("position") }

  validates :password, length: {minimum: 6}
  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true

  def q_items_size
    self.q_items.size
  end
end