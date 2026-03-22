class Trope < ApplicationRecord
  has_many :book_tropes, dependent: :destroy
  has_many :books, through: :book_tropes

  validates :name, presence: true, uniqueness: true

  scope :alphabetical, -> { order(:name) }
end
