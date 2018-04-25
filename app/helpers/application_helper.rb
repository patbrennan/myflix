module ApplicationHelper
  def logged_in?
    session[:user_id] && User.find(session[:user_id])
  end

  def current_user
    @user ||= User.find(session[:user_id])
  end

  def options_for_video_reviews
    (1..5).map { |num| [pluralize(num, "Star"), num] }
  end

  def current_user_rating(video_obj)
    review = Review.find_by(video_id: video_obj.id, user_id: current_user.id)
    review ? review.rating : "Not Rated"
  end

  def format_user_rating(video_obj)
    rating = user_rating(video_obj)
    stars = rating > 1 ? "stars" : "star"
    "#{rating} #{stars}"
  end
end
