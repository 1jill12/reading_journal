class BingoSquare < ApplicationRecord
  belongs_to :bingo_card
  has_many :user_bingo_squares, dependent: :destroy

  validates :trope_name, presence: true
  validates :position, presence: true, uniqueness: { scope: :bingo_card_id }

  def free_space?
    free_space == true
  end
end
