class ReadingGoal < ApplicationRecord
  belongs_to :user

  TYPES = {
    'books_per_year'  => 'Books per Year',
    'pages_per_year'  => 'Pages per Year',
    'books_per_month' => 'Books per Month',
    'custom'          => 'Custom Goal'
  }.freeze

  STATUSES = %w[active completed abandoned].freeze

  MONTH_NAMES = Date::MONTHNAMES.compact.freeze

  validates :goal_type, inclusion: { in: TYPES.keys }
  validates :target,    numericality: { greater_than: 0 }
  validates :year,      presence: true, if: -> { %w[books_per_year pages_per_year books_per_month].include?(goal_type) }
  validates :month,     presence: true, inclusion: { in: 1..12 }, if: -> { goal_type == 'books_per_month' }
  validates :title,     presence: true, if: -> { goal_type == 'custom' }

  scope :active,    -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
  scope :recent,    -> { order(created_at: :desc) }

  after_save :check_completion

  def progress
    case goal_type
    when 'books_per_year'
      finished_books_scope.count
    when 'pages_per_year'
      finished_books_scope.sum(:pages)
    when 'books_per_month'
      finished_books_in_month_scope.count
    when 'custom'
      current_progress
    end
  end

  def percentage
    return 100 if completed?
    [(progress.to_f / target * 100).round, 100].min
  end

  def completed?
    status == 'completed'
  end

  def abandoned?
    status == 'abandoned'
  end

  def display_title
    return title if goal_type == 'custom'
    case goal_type
    when 'books_per_year'  then "Read #{target} books in #{year}"
    when 'pages_per_year'  then "Read #{number_with_delimiter(target)} pages in #{year}"
    when 'books_per_month' then "Read #{target} books in #{MONTH_NAMES[month - 1]} #{year}"
    end
  end

  def display_progress
    case goal_type
    when 'pages_per_year' then "#{number_with_delimiter(progress)} / #{number_with_delimiter(target)} pages"
    when 'custom'         then "#{progress} / #{target}"
    else                       "#{progress} / #{target} books"
    end
  end

  private

  def check_completion
    return if completed? || abandoned?
    if progress >= target
      update_columns(status: 'completed', completed_at: Time.current)
    end
  end

  def finished_books_scope
    user.books.where(status: 'Finished')
        .where(finished_at: Date.new(year, 1, 1).beginning_of_day..Date.new(year, 12, 31).end_of_day)
  end

  def finished_books_in_month_scope
    start_date = Date.new(year, month, 1)
    user.books.where(status: 'Finished')
        .where(finished_at: start_date.beginning_of_month..start_date.end_of_month)
  end

  def number_with_delimiter(num)
    num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end
