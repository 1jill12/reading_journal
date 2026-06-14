class BingoCardsController < ApplicationController
  def index
    @bingo_cards = BingoCard.all
    @user_bingo_card_ids = current_user.user_bingo_cards.pluck(:bingo_card_id)
  end

  def show
    @bingo_card = BingoCard.includes(:bingo_squares).find(params[:id])
    @user_bingo_card = current_user.user_bingo_cards.find_by(bingo_card: @bingo_card)

    redirect_to bingo_cards_path, alert: "You haven't joined this card yet." unless @user_bingo_card
  end
end
