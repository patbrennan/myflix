class QItemsController < ApplicationController
  before_action :require_user

  def index
    @q_items = current_user.q_items
  end

  def create
    @q_item = QItem.new(user: current_user, video_id: params[:video_id], position: current_user.next_position)
    @video = Video.find(params[:video_id])

    if !@video.in_q?(current_user) && @q_item.save
      flash[:success] = "Item added to your queue."
      redirect_to my_queue_path
    else
      flash[:error] = "Video is already in your queue."
      redirect_to my_queue_path
    end
  end

  def destroy
    @q_item = QItem.find_by(id: params[:id])
    @video = @q_item.video if @q_item

    if @q_item && @video.in_q?(current_user) && @q_item.destroy
      flash[:success] = "#{@video.title} removed from your queue."
      current_user.q_items.reload
      current_user.normalize_q_positions
      redirect_to my_queue_path
    else
      flash[:error] = "Something went wrong."
      redirect_to my_queue_path
    end
  end

  def update_q
    begin
      update_q_items
      current_user.normalize_q_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position numbers."
    end

    redirect_to my_queue_path
  end

  private

  def update_q_items
    # When using transactions, this block MUST raise an exception in order for
    # them to roll back all transactions. That's why we use the update! (bang)
    # method. Normally, it wouldn't raise an exception.
    ActiveRecord::Base.transaction do
      params[:q_items].each do |q_item_data|
        q_item = QItem.find(q_item_data["id"])
        q_item.update_attributes!(position: q_item_data["position"], rating: q_item_data["rating"]) if q_item.user == current_user
      end
    end
  end
end
