module ApplicationHelper
  def logged_in?
    session[:user_id] && User.find(session[:user_id])
  end

  def current_user
    User.find(session[:user_id])
  end

  def user_rating(video_obj)
    Review.find_by(video_id: video_obj.id, user_id: current_user.id).rating
  end
end
