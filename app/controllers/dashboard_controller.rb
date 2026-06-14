class DashboardController < ApplicationController
  def index
    @total_books = current_user.books.count
    @finished_books = current_user.books.where(status: 'Finished').count
    @currently_reading = current_user.books.where(status: 'Currently Reading').count
    @want_to_read = current_user.books.where(status: 'Want to Read').count
    @total_pages = current_user.books.sum(:pages)
    @average_rating = current_user.books.where.not(rating: nil).average(:rating)&.round(1)
    @recent_books = current_user.books.order(created_at: :desc).limit(5)
    @active_goals = current_user.reading_goals.active.recent.limit(3)
    @top_genre    = current_user.books.where.not(genre: [nil, ''])
                                 .group(:genre).order('count_all DESC')
                                 .limit(1).count.keys.first
  end
end
