class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :ensure_admin, only: [:edit, :update, :destroy]

  def index
    @rooms = current_user.rooms.includes(:users, :created_by)
  end

  def show
    @room_members = @room.room_members.includes(:user)
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.created_rooms.build(room_params)

    if @room.save
      @room.room_members.create!(user: current_user, role: :admin)
      redirect_to @room, notice: 'ルームが作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      respond_to do |format|
        format.html { redirect_to @room, notice: 'ルーム情報が更新されました。' }
        format.json { render json: { name: @room.name, description: @room.description } }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @room.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path, notice: 'ルームが削除されました。'
  end

  def join
  end

  def join_by_code
    invitation_code = params[:invitation_code]&.upcase
    room = Room.find_by(invitation_code: invitation_code)

    if room.nil?
      redirect_to join_rooms_path, alert: '招待コードが正しくありません。'
      return
    end

    if current_user.member_of?(room)
      redirect_to room, notice: '既にこのルームのメンバーです。'
      return
    end

    room.room_members.create!(user: current_user, role: :member)
    redirect_to room, notice: "#{room.name}に参加しました！"
  end

  private

  def set_room
    @room = current_user.rooms.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path, alert: 'ルームが見つからないか、アクセス権限がありません。'
  end

  def ensure_admin
    unless current_user.admin_of?(@room)
      redirect_to @room, alert: '管理者権限が必要です。'
    end
  end

  def room_params
    params.require(:room).permit(:name, :description)
  end
end
