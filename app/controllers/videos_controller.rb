class VideosController < ApplicationController
  before_action :require_user, except: [:front]

  def front
    redirect_to home_path if logged_in?
  end

  def index
    @categories = Category.all.includes(:videos)
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
    @review = Review.new
  end

  def search
    query = params[:query]
    @results = Video.search_by_title(query)
  end

  private

  def video_params
    params.require(:video).permit! # TODO: impl strict params
  end
end