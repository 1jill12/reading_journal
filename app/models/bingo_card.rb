class BingoCard < ApplicationRecord
  has_many :bingo_squares, -> { order(:position) }, dependent: :destroy
  has_many :user_bingo_cards, dependent: :destroy

  validates :title, presence: true
end
