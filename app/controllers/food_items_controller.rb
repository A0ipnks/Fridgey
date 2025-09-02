class FoodItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :ensure_room_member
  before_action :set_food_item, only: [:show, :edit, :update, :destroy]
  before_action :ensure_can_edit, only: [:edit, :update, :destroy]


  def show
  end

  def new
    @food_item = @room.food_items.build
  end

  def create
    @food_item = @room.food_items.build(food_item_params)
    @food_item.registered_by = current_user

    if @food_item.save
      redirect_to [@room, @food_item], notice: '食材が登録されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @food_item.update(food_item_params)
      redirect_to [@room, @food_item], notice: '食材情報が更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @food_item.destroy
    redirect_to @room, notice: '食材が削除されました。'
  end

  private

  def set_room
    @room = current_user.rooms.find(params[:room_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path, alert: '冷蔵庫が見つからないか、アクセス権限がありません。'
  end

  def ensure_room_member
    unless current_user.member_of?(@room)
      redirect_to rooms_path, alert: 'この冷蔵庫にアクセスする権限がありません。'
    end
  end

  def set_food_item
    @food_item = @room.food_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @room, alert: '食材が見つかりません。'
  end

  def ensure_can_edit
    unless @food_item.registered_by == current_user || current_user.admin_of?(@room)
      redirect_to [@room, @food_item], alert: 'この食材を編集する権限がありません。'
    end
  end

  def food_item_params
    params.require(:food_item).permit(:name, :category, :expiration_date, :quantity, :memo, :restriction_tags, :used_by_id)
  end
end