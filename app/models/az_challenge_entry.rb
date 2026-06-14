class AzChallengeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :book, optional: true

  validates :letter, presence: true, inclusion: { in: ('A'..'Z').to_a }
  validates :year,   presence: true
  validates :letter, uniqueness: { scope: [:user_id, :year] }

  def display_title
    book&.title.presence || custom_title.presence || '—'
  end

  def display_author
    book&.author
  end

  def cover_url
    book&.cover_url
  end
end
