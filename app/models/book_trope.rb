class BookTrope < ApplicationRecord
  belongs_to :book
  belongs_to :trope

  validates :trope_id, uniqueness: { scope: :book_id }

  after_create :auto_cover_bingo_squares

  private

  def auto_cover_bingo_squares
    return unless book.user

    book.user.user_bingo_cards.includes(bingo_card: :bingo_squares).each do |user_bingo_card|
      user_bingo_card.bingo_card.bingo_squares
        .where(trope_name: trope.name)
        .each do |square|
          user_bingo_card.user_bingo_squares.find_or_create_by(bingo_square: square) do |ubs|
            ubs.book = book
          end
        end
    end
  end
end
