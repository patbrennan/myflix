class QItemsController < ApplicationController
  before_action :require_user

  def index
    @q_items = current_user.q_items
  end

  def create
    last_position = current_user.q_items_size + 1
    @q_item = QItem.new(user: current_user, video_id: params[:video_id], position: last_position)

    if !video_in_q?(current_user, params[:video_id]) && @q_item.save
      flash[:success] = "Item added to your queue."
      redirect_to my_queue_path
    else
      flash[:error] = "Something went wrong."
      redirect_to login_path
    end
  end

  def destroy
    @q_item = QItem.find_by(id: params[:id])
    @video = @q_item.video if @q_item

    if @q_item && video_in_q?(current_user, @video.id) && @q_item.destroy
      flash[:success] = "#{@video.title} removed from your queue."
      redirect_to my_queue_path
    else
      flash[:error] = "Something went wrong."
      redirect_to my_queue_path
    end
  end

  private

  def video_in_q?(user, video_id)
    user.q_items.any? { |q_item| q_item.video_id == video_id.to_i }
  end
end
