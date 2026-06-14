class UserBingoCardsController < ApplicationController
  def create
    bingo_card = BingoCard.find(params[:bingo_card_id])
    user_bingo_card = current_user.user_bingo_cards.find_or_initialize_by(bingo_card: bingo_card)

    if user_bingo_card.new_record?
      user_bingo_card.save!
      # Auto-mark the free space (position 12)
      free_square = bingo_card.bingo_squares.find_by(free_space: true)
      user_bingo_card.user_bingo_squares.find_or_create_by(bingo_square: free_square) if free_square
      redirect_to bingo_card_path(bingo_card), notice: "You joined \"#{bingo_card.title}\"!"
    else
      redirect_to bingo_card_path(bingo_card)
    end
  end

  def destroy
    user_bingo_card = current_user.user_bingo_cards.find(params[:id])
    bingo_card = user_bingo_card.bingo_card
    user_bingo_card.destroy
    redirect_to bingo_cards_path, notice: "Left \"#{bingo_card.title}\"."
  end
end
