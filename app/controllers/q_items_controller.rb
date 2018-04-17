class QItemsController < ApplicationController
  before_action :require_user

  def index
    @q_items = current_user.q_items
  end
end
