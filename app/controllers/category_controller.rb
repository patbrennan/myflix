class CategoryController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @videos = @category.videos
  end
  
  # TODO: sluggify urls w/to_param
end