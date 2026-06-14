class FollowsController < ApplicationController
  def create
    user = User.find(params[:following_id])
    current_user.active_follows.find_or_create_by!(following: user) unless current_user == user
    redirect_to user_path(user)
  end

  def destroy
    follow = current_user.active_follows.find_by(following_id: params[:following_id])
    follow&.destroy
    redirect_to user_path(params[:following_id])
  end
end
