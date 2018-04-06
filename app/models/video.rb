class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, :description, presence: true

  def self.search_by_title(string)
    return [] if string.blank?
    where("title LIKE ?", "%#{string}%").order("created_at DESC")
  end
end