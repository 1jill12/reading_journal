require 'test_helper'

# Covers: AC-12, AC-13, AT11, AT12 (join table uniqueness + auto bingo coverage)
class BookTropeTest < ActiveSupport::TestCase
  # uniqueness — AT11, AC-12
  test 'rejects duplicate book-trope association' do
    # Arrange
    existing = book_tropes(:one)

    # Act
    duplicate = BookTrope.new(book: existing.book, trope: existing.trope)

    # Assert
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:trope_id], 'has already been taken'
  end

  # association integrity
  test 'belongs to a book and a trope' do
    bt = book_tropes(:one)
    assert_equal books(:one), bt.book
    assert_equal tropes(:enemies_to_lovers), bt.trope
  end

  # AT3 — tropes associated correctly
  test 'book has correct tropes via join table' do
    book = books(:one)
    trope_names = book.tropes.map(&:name)

    # Arrange/Assert
    assert_includes trope_names, 'Enemies to Lovers'
    assert_includes trope_names, 'Slow Burn'
  end

  # AT4 — book with no tropes
  test 'book with no tropes has empty tropes collection' do
    book = books(:two)
    assert_equal 0, book.tropes.count
  end
end
