require 'test_helper'

# Covers: AC-3, AC-4, AT5, AT6 (Review model validations)
class ReviewTest < ActiveSupport::TestCase
  # AT5 — full review persisted
  test 'valid review with rating, spice_level, and text' do
    review = Review.new(
      user: users(:two),
      book: books(:one),
      rating: 4.0,
      spice_level: 3,
      review_text: 'Great read'
    )
    assert review.valid?
  end

  # E1 — empty review is allowed
  test 'valid review with no fields set' do
    review = Review.new(user: users(:two), book: books(:one))
    assert review.valid?
  end

  # AC-3 — individual optional fields
  test 'valid review with only review_text' do
    review = Review.new(user: users(:two), book: books(:one), review_text: 'Loved it')
    assert review.valid?
  end

  # spice_level range
  test 'invalid spice_level below 1' do
    review = Review.new(user: users(:two), book: books(:one), spice_level: 0)
    assert_not review.valid?
    assert review.errors[:spice_level].any?
  end

  test 'invalid spice_level above 5' do
    review = Review.new(user: users(:two), book: books(:one), spice_level: 6)
    assert_not review.valid?
    assert review.errors[:spice_level].any?
  end

  # AT6, AC-4 — one review per user per book
  test 'rejects second review for same user and book' do
    # Arrange — fixture :one already has user :one + book :one
    duplicate = Review.new(
      user: users(:one),
      book: books(:one),
      review_text: 'Second attempt'
    )

    # Assert
    assert_not duplicate.valid?
    assert duplicate.errors[:user_id].any?
  end

  # associations
  test 'belongs to user and book' do
    review = reviews(:one)
    assert_equal users(:one), review.user
    assert_equal books(:one), review.book
  end
end
