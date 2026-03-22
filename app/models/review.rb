class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, uniqueness: { scope: :book_id, message: 'already reviewed this book' }
  validates :spice_level, inclusion: { in: 1..5, allow_nil: true }
  validate :requires_content

  private

  def requires_content
    return if rating.present? || spice_level.present? || review_text.present?

    # E1: empty review is allowed — no validation error
  end
end
