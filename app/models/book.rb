class Book < ApplicationRecord
  STATUSES = ['Want to Read', 'Currently Reading', 'Finished', 'DNF'].freeze
  FORMATS  = ['Physical', 'Audiobook', 'E-Reader'].freeze

  GENRES = [
    'Fantasy', 'Science Fiction', 'Romance', 'Mystery', 'Thriller',
    'Horror', 'Historical Fiction', 'Literary Fiction', 'Contemporary Fiction',
    'Young Adult', 'Middle Grade', 'Non-Fiction', 'Memoir', 'Biography',
    'Self-Help', 'Graphic Novel', 'Poetry', 'Other'
  ].freeze

  TROPES = [
    # Romantasy
    'Enemies to Lovers', 'Fake Dating', 'Slow Burn', 'Forbidden Romance',
    'Found Family', 'Chosen One', 'Fae/Fair Folk', 'Magic System', 'Prophecy',
    'Second Chance Romance', 'Love Triangle', 'Grumpy x Sunshine',
    'Touch Starved', 'Morally Grey Love Interest', 'Forced Proximity',
    # Thriller
    'Unreliable Narrator', 'Plot Twist', 'Red Herring', 'Missing Person',
    'Corrupt Institution', 'Locked Room Mystery', 'Race Against Time',
    'Hidden Identity', 'Double Cross', 'Dark Secret', 'Psychological Manipulation',
    'Serial Killer', 'Whodunit',
    # Dark Academia
    'Secret Society', 'Forbidden Knowledge', 'Gothic Setting',
    'Obsessive Friendship', 'Class Divide', 'Rivalry', 'Ancient Curse',
    'Unrequited Love', 'Elite School', 'Moral Ambiguity', 'Murder Mystery',
    # General
    'Redemption Arc', 'Coming of Age', 'Reluctant Hero',
    'The Mentor Dies', 'Portal Fantasy', 'Chosen Family', 'Revenge Plot',
    'Unlikely Allies'
  ].sort.freeze

  has_many :reflections, dependent: :destroy
  has_many :book_tropes, dependent: :destroy
  has_many :tropes, through: :book_tropes
  has_many :reviews, dependent: :destroy
  has_many :user_bingo_squares, dependent: :nullify

  belongs_to :user, optional: true

  before_save :normalize_author
  before_save :track_reading_dates, if: :status_changed?
  after_create  :fetch_cover_from_google_books
  after_create  :log_book_added
  after_save    :log_book_finished,      if: -> { saved_change_to_status? && status == 'Finished' }
  after_save    :auto_assign_az_challenge, if: -> { saved_change_to_status? && status == 'Finished' }

  private

  def normalize_author
    return unless author.present?
    # Strip whitespace, collapse spaces, remove periods after single initials (J. → J)
    self.author = author.strip.gsub(/\s+/, ' ').gsub(/\b([A-Z])\./, '\1')
  end

  def log_book_added
    return unless user
    Activity.log(user: user, action_type: 'book_added', trackable: self)
  end

  def log_book_finished
    return unless user
    Activity.log(user: user, action_type: 'book_finished', trackable: self)
  end

  def track_reading_dates
    self.started_at  ||= Time.current if status == 'Currently Reading'
    self.finished_at   = Time.current if status == 'Finished' && finished_at.nil?
    self.started_at  ||= Time.current if status == 'Finished' && started_at.nil?
  end

  def fetch_cover_from_google_books
    return if cover_url.present?

    book_info = GoogleBooksService.fetch_book_info(title, author)
    if book_info && book_info[:cover_url]
      update_column(:cover_url, book_info[:cover_url])
    end
  end

  def auto_assign_az_challenge
    return unless user && title.present?
    letter = title.upcase.gsub(/^(A |AN |THE )/, '').first
    return unless letter =~ /[A-Z]/
    year = (finished_at || Time.current).year
    user.az_challenge_entries.find_or_create_by(letter: letter, year: year) do |entry|
      entry.book_id = id
    end
  end
end
