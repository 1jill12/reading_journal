class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = current_user.books
  end

  # GET /books/search
  def search
    @query   = params[:q].to_s.strip
    @results = @query.present? ? GoogleBooksService.search(@query) : []

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

  # GET /books/1 or /books/1.json
  def show
    @review = @book.reviews.find_or_initialize_by(user: current_user)
    @tropes = Trope.alphabetical
  end

  # GET /books/new
  def new
    @book = current_user.books.new
    @tropes = Trope.alphabetical
  end

  # GET /books/1/edit
  def edit
    @tropes = Trope.alphabetical
  end

  # POST /books or /books.json
  def create
    @book = current_user.books.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, notice: "Book was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = current_user.books.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.expect(book: [ :title, :author, :genre, :format, :pages, :status, :cover_url, :rating, :spice_rating, :sadness_rating, :humor_rating, :suspense_rating, :description, :started_at, :finished_at, trope_ids: [] ])
    end
end
