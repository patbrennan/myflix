class ReviewsController < ApplicationController
  before_action :require_user, only: [:create]

  def create
    @video = Video.find(params[:video_id])
    @user = current_user
    @review = Review.new(review_params.merge video: @video, user: @user)

    if @review.save
      flash[:success] = "Review Submitted!"
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews
      flash[:error] = "Something went wrong."
      render "videos/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :description)
  end
end