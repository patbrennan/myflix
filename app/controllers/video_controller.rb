class VideoController < ApplicationController
  def index
    @categories = Category.all.includes(:videos)
  end
  
  def show
    @video = Video.find(params[:id])
  end
end