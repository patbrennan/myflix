class VideosController < ApplicationController
  def index
    @categories = Category.all.includes(:videos)
  end

  def show
    @video = Video.find(params[:id])
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