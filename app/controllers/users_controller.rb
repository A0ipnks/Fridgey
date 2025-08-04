class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_path(@user), notice: 'プロフィールが更新されました。' }
        format.json { render json: { name: @user.display_name, email: @user.email } }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @user.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:display_name)
  end
end
