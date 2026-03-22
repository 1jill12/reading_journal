require 'test_helper'

# Covers: AC-3, AC-4, AT5, AT6
class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @book = books(:one)
    sign_in @user
  end

  # AT5 — AC-3: create review with all fields
  test 'creates review with rating, spice_level, and text' do
    # Arrange
    other_book = books(:two)

    # Act
    post book_review_path(other_book), params: {
      review: { rating: 4, spice_level: 3, review_text: 'Loved it' }
    }

    # Assert
    assert_redirected_to other_book
    assert_equal 'Review saved.', flash[:notice]
    review = Review.find_by(user: @user, book: other_book)
    assert_not_nil review
    assert_equal 4.0, review.rating
    assert_equal 3, review.spice_level
    assert_equal 'Loved it', review.review_text
  end

  # E1 — AC-3: empty review is allowed
  test 'creates review with no fields' do
    other_book = books(:two)
    post book_review_path(other_book), params: { review: {} }
    assert_redirected_to other_book
    assert Review.exists?(user: @user, book: other_book)
  end

  # AT6 — AC-4: second review for same book is rejected
  test 'rejects second review for the same book' do
    # Arrange — fixture :one already has user :one + book :one
    # Act
    post book_review_path(@book), params: {
      review: { review_text: 'Trying again' }
    }

    # Assert
    assert_redirected_to @book
    assert flash[:alert].present?
    assert_equal 1, Review.where(user: @user, book: @book).count
  end

  # update
  test 'updates existing review' do
    patch book_review_path(@book), params: {
      review: { review_text: 'Updated thoughts', spice_level: 5 }
    }
    assert_redirected_to @book
    assert_equal 'Review updated.', flash[:notice]
    assert_equal 'Updated thoughts', reviews(:one).reload.review_text
  end

  # destroy
  test 'deletes own review' do
    review_id = reviews(:one).id
    delete book_review_path(@book)
    assert_redirected_to @book
    assert_not Review.exists?(review_id)
  end

  private

  def sign_in(user)
    post user_session_path, params: {
      user: { email: user.email, password: 'password123' }
    }
  end
end
