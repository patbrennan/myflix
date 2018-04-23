class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :reviews
  has_many :q_items, -> { order(:position) }

  validates :password, length: {minimum: 6}
  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true

  def next_position
    self.q_items.size + 1
  end

  def normalize_q_positions
    self.q_items.each_with_index do |q_item, i|
      q_item.update(position: i + 1)
    end
  end
end