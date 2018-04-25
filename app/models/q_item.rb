class QItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_presence_of :user_id, :video_id
  validates_numericality_of :position, only_integer: true

  # Requires user to be logged in (current_user) or set, or won't work
  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating) # bypass validation
    else
      new_review = Review.new(user: user, video: video, rating: new_rating)
      new_review.save(validate: false)
    end
  end

  private

  def review
    @review ||= Review.where(video_id: video.id, user_id: user.id).first
  end
end