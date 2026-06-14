require 'net/http'
require 'json'

class GoogleBooksService
  MAX_RESULTS = 20

  def self.search(query)
    encoded = URI.encode_uri_component(query)
    url = URI("https://www.googleapis.com/books/v1/volumes?q=#{encoded}&maxResults=#{MAX_RESULTS}&key=#{api_key}")

    data = fetch(url)
    return [] unless data['items']&.any?

    data['items'].filter_map { |item| parse_volume(item) }
  rescue StandardError => e
    Rails.logger.error "Google Books search error: #{e.message}"
    []
  end

  def self.fetch_book_info(title, author)
    query = URI.encode_uri_component("#{title} #{author}")
    url = URI("https://www.googleapis.com/books/v1/volumes?q=#{query}&key=#{api_key}")

    data = fetch(url)
    return nil unless data['items']&.any?

    parse_volume(data['items'].first)
  rescue StandardError => e
    Rails.logger.error "Google Books API error: #{e.message}"
    nil
  end

  def self.api_key
    Rails.application.credentials.google_books_api_key
  end

  def self.fetch(url)
    JSON.parse(Net::HTTP.get(url))
  end

  def self.parse_volume(item)
    info = item['volumeInfo']
    return nil unless info['title'].present?

    cover = info.dig('imageLinks', 'thumbnail') ||
            info.dig('imageLinks', 'smallThumbnail')
    # Upgrade to HTTPS and larger image
    cover = cover&.gsub('http://', 'https://')&.gsub('zoom=1', 'zoom=2')

    {
      google_books_id: item['id'],
      title:       info['title'],
      author:      info['authors']&.first,
      pages:       info['pageCount'],
      cover_url:   cover,
      description: info['description'],
      genre:       info['categories']&.first
    }
  end
  private_class_method :fetch, :parse_volume, :api_key
end
