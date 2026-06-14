class FeedController < ApplicationController
  def index
    @activities = current_user.feed_activities.limit(50).includes(:user, :trackable)
  end
end
