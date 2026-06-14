class UserBingoCard < ApplicationRecord
  belongs_to :user
  belongs_to :bingo_card
  has_many :user_bingo_squares, dependent: :destroy

  validates :user_id, uniqueness: { scope: :bingo_card_id, message: "is already playing this card" }

  # Positions for a 5x5 grid (0-indexed)
  ROWS      = [[0,1,2,3,4],[5,6,7,8,9],[10,11,12,13,14],[15,16,17,18,19],[20,21,22,23,24]]
  COLS      = [[0,5,10,15,20],[1,6,11,16,21],[2,7,12,17,22],[3,8,13,18,23],[4,9,14,19,24]]
  DIAGONALS = [[0,6,12,18,24],[4,8,12,16,20]]

  def covered_positions
    covered = user_bingo_squares.joins(:bingo_square).pluck("bingo_squares.position").to_set
    # Free space (position 12) is always covered
    bingo_card.bingo_squares.where(free_space: true).pluck(:position).each { |p| covered.add(p) }
    covered
  end

  def bingo?
    pos = covered_positions
    (ROWS + COLS + DIAGONALS).any? { |line| line.all? { |p| pos.include?(p) } }
  end

  def completed_lines
    pos = covered_positions
    (ROWS + COLS + DIAGONALS).select { |line| line.all? { |p| pos.include?(p) } }
  end
end
