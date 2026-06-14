class UsersController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @users = @query.present? ? User.where('username ILIKE :q OR email ILIKE :q', q: "%#{@query}%")
                                   .where.not(id: current_user.id).limit(20)
                             : []
  end

  def show
    @user = User.find(params[:id])

    if @user.private_profile? && !current_user.following?(@user) && @user != current_user
      @private = true
      return
    end

    @books      = @user.books.order(created_at: :desc).limit(12)
    @finished   = @user.books.where(status: 'Finished').count
    @activities = @user.activities.recent.limit(20).includes(:trackable)
  end
end
