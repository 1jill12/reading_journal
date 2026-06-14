class UserBingoSquare < ApplicationRecord
  belongs_to :user_bingo_card
  belongs_to :bingo_square
  belongs_to :book, optional: true

  validates :bingo_square_id, uniqueness: { scope: :user_bingo_card_id }

  after_create :log_activity

  private

  def log_activity
    return if bingo_square.free_space?
    user = user_bingo_card.user
    Activity.log(user: user, action_type: 'bingo_covered', trackable: self)
  end
end
