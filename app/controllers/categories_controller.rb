class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @videos = @category.recent_videos
  end

  def recent
    @videos = Category.recent_videos
  end

  # TODO: sluggify urls w/to_param
end