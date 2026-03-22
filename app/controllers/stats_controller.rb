class StatsController < ApplicationController
  def index
    @year          = Date.current.year
    @finished      = current_user.books.where(status: 'Finished')
    @all_books     = current_user.books

    yearly_scope   = @finished.where(finished_at: Date.new(@year, 1, 1)..)
    @books_this_year  = yearly_scope.count
    @pages_this_year  = yearly_scope.sum(:pages)
    @yearly_goal      = current_user.reading_goal

    @total_books    = @all_books.count
    @total_finished = @finished.count
    @total_pages    = @finished.sum(:pages)
    @avg_rating     = @finished.where.not(rating: nil).average(:rating)&.round(1)

    @top_authors        = @all_books.where.not(author: [nil, ''])
                                   .group("LOWER(TRIM(REGEXP_REPLACE(author, '\\.', '', 'g')))")
                                   .count
                                   .max_by(5) { |_, c| c }
                                   .map { |normalized, count| [@all_books.where("LOWER(TRIM(REGEXP_REPLACE(author, '\\.', '', 'g'))) = ?", normalized).pick(:author), count] }
    @status_breakdown   = @all_books.group(:status).count
    @rating_breakdown   = @finished.where.not(rating: nil).group(:rating).count.sort
    @top_tropes         = top_tropes
    @avg_spice          = current_user.reviews.where.not(spice_level: nil).average(:spice_level)&.round(1)

    @monthly_data = build_monthly_data

    @avg_pages_per_day, @avg_days_per_book = reading_speed_stats

    @current_reads_with_eta = build_etas

    activity  = activity_dates
    @current_streak = current_streak(activity)
    @longest_streak = longest_streak(activity)
  end

  private

  def build_monthly_data
    (11.downto(0)).map { |i| Date.current.beginning_of_month - i.months }.map do |month|
      range = month.beginning_of_month..month.end_of_month
      scope = @finished.where(finished_at: range)
      { label: month.strftime('%b %y'), books: scope.count, pages: scope.sum(:pages) }
    end
  end

  def reading_speed_stats
    with_dates = @finished.where.not(started_at: nil, finished_at: nil).where('pages > 0')
    return [nil, nil] unless with_dates.exists?

    speeds = with_dates.map do |b|
      days = [(b.finished_at.to_date - b.started_at.to_date).to_i, 1].max
      [b.pages.to_f / days, days]
    end
    avg_speed = speeds.sum { |s, _| s } / speeds.size
    avg_days  = speeds.sum { |_, d| d } / speeds.size
    [avg_speed.round(1), avg_days.round]
  end

  def build_etas
    return [] unless @avg_pages_per_day&.positive?

    current_user.books.where(status: 'Currently Reading').filter_map do |book|
      next unless book.pages.to_i > 0
      started       = book.started_at&.to_date || Date.current
      days_reading  = [(Date.current - started).to_i, 0].max
      pages_read    = (days_reading * @avg_pages_per_day).round
      remaining     = [book.pages - pages_read, 0].max
      days_left     = (remaining / @avg_pages_per_day).ceil
      { book: book, eta: Date.current + days_left.days, percent: [(pages_read.to_f / book.pages * 100).round, 100].min }
    end
  end

  def top_tropes
    Trope
      .joins(:book_tropes => :book)
      .where(books: { user_id: current_user.id })
      .group('tropes.name')
      .order('COUNT(book_tropes.id) DESC')
      .limit(5)
      .count('book_tropes.id')
  end

  def activity_dates
    book_dates       = current_user.books.pluck(:created_at).map(&:to_date)
    reflection_dates = Reflection.joins(:book).where(books: { user_id: current_user.id }).pluck(:created_at).map(&:to_date)
    (book_dates + reflection_dates).uniq.sort
  end

  def current_streak(dates)
    return 0 if dates.empty?
    check = dates.include?(Date.current) ? Date.current : (dates.include?(Date.current - 1.day) ? Date.current - 1.day : nil)
    return 0 unless check

    streak, date = 0, check
    while dates.include?(date)
      streak += 1
      date   -= 1.day
    end
    streak
  end

  def longest_streak(dates)
    return 0 if dates.empty?
    longest, current = 1, 1
    dates.each_cons(2) do |a, b|
      current = (b - a == 1) ? current + 1 : 1
      longest = [longest, current].max
    end
    longest
  end
end
