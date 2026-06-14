class AzChallengesController < ApplicationController
  def index
    @year = (params[:year] || Date.current.year).to_i
    backfill_finished_books
    @entries = current_user.az_challenge_entries.where(year: @year)
                           .includes(:book).index_by(&:letter)
  end

  private

  def backfill_finished_books
    current_user.books.where(status: 'Finished').each do |book|
      next unless book.title.present?
      letter = book.title.upcase.gsub(/^(A |AN |THE )/, '').first
      next unless letter =~ /[A-Z]/
      year = (book.finished_at || book.updated_at).year
      current_user.az_challenge_entries
                  .find_or_create_by(letter: letter, year: year) do |entry|
        entry.book_id = book.id
      end
    end
  end

  public

  def destroy
    current_user.az_challenge_entries
                .find_by(letter: params[:id], year: params[:year])
                &.destroy
    redirect_to az_challenges_path(year: params[:year])
  end
end
