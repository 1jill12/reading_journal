class Book < ApplicationRecord
  STATUSES = ['Want to Read', 'Currently Reading', 'Finished', 'DNF']
  
  has_many :reflections, dependent: :destroy

  after_create :fetch_cover_from_google_books

  private

  def fetch_cover_from_google_books
    return unless cover_url.blank?

    book_info = GoogleBooksService.fetch_book_info(title, author)
    if book_info && book_info[:cover_url]
      update_column(:cover_url, book_info[:cover_url])
    end
  end
end
