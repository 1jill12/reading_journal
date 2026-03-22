require 'test_helper'

# Covers: AC-11, AC-12 (Trope model validations and uniqueness)
class TropeTest < ActiveSupport::TestCase
  # name validation
  test 'valid with a name' do
    trope = Trope.new(name: 'Portal Fantasy')
    assert trope.valid?
  end

  test 'invalid without a name' do
    trope = Trope.new(name: nil)
    assert_not trope.valid?
    assert_includes trope.errors[:name], "can't be blank"
  end

  # uniqueness — AC-12 unique index
  test 'rejects duplicate names' do
    # Arrange
    existing = tropes(:enemies_to_lovers)

    # Act
    duplicate = Trope.new(name: existing.name)

    # Assert
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], 'has already been taken'
  end

  # alphabetical scope
  test 'alphabetical scope returns tropes ordered by name' do
    names = Trope.alphabetical.pluck(:name)
    assert_equal names.sort, names
  end

  # associations
  test 'has many books through book_tropes' do
    trope = tropes(:enemies_to_lovers)
    assert_respond_to trope, :books
    assert_includes trope.books, books(:one)
  end
end
