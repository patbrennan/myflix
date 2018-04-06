class Category < ActiveRecord::Base
  has_many :videos, -> { order("title") }

  # Most recent of all videos
  def self.recent_videos
    Video.all.limit(6).order("created_at DESC")
  end

  # Most recent videos in a single category
  def recent_category_videos
    self.videos.limit(6).order(created_at: :desc)
  end
end