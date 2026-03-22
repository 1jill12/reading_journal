class ReviewsController < ApplicationController
  before_action :set_book

  def edit
    @review = current_user.reviews.find_by!(book: @book)
  end

  def create
    @review = @book.reviews.new(review_params.merge(user: current_user))

    if @review.save
      redirect_to @book, notice: 'Review saved.'
    else
      redirect_to @book, alert: @review.errors.full_messages.to_sentence
    end
  end

  def update
    @review = current_user.reviews.find_by!(book: @book)

    if @review.update(review_params)
      redirect_to @book, notice: 'Review updated.'
    else
      redirect_to @book, alert: @review.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.reviews.find_by!(book: @book).destroy
    redirect_to @book, notice: 'Review removed.'
  end

  private

  def set_book
    @book = current_user.books.find(params[:book_id])
  end

  def review_params
    params.fetch(:review, {}).permit(:rating, :spice_level, :review_text)
  end
end
