class Category < ActiveRecord::Base
  has_many :videos, -> { order("created_at DESC") }
  validates_presence_of :name

  # Most recent of all videos
  def self.recent_videos
    Video.all.order(created_at: :desc).limit(6)
  end

  # Most recent videos in a single category
  def recent_videos
    videos = self.videos

    return [] unless videos
    videos.first(6)
  end
end