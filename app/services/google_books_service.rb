require 'net/http'
require 'json'

class GoogleBooksService
  def self.fetch_book_info(title, author)
    query = "#{title} #{author}".gsub(' ', '+')
    url = URI("https://www.googleapis.com/books/v1/volumes?q=#{query}&key=#{Rails.application.credentials.google_books_api_key}")

    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    return nil unless data['items']&.any?

    book_data = data['items'].first['volumeInfo']
    {
      title: book_data['title'],
      authors: book_data['authors'],
      description: book_data['description'],
      cover_url: book_data['imageLinks']&.[]('thumbnail'),
      pages: book_data['pageCount']
    }
  rescue StandardError => e
    Rails.logger.error "Google Books API error: #{e.message}"
    nil
  end
end
