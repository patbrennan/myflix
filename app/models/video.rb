class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }

  validates :title, :description, presence: true

  def self.search_by_title(string)
    return [] if string.blank?
    where("title LIKE ?", "%#{string}%").order("created_at DESC")
  end

  def avg_rating
    reviews = self.reviews
    self.reviews.average(:rating).to_f.round(1)
  end
end