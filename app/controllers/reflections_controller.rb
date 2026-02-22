class ReflectionsController < ApplicationController
  before_action :set_book

  def create
    @reflection = @book.reflections.build(reflection_params)

    if @reflection.save
      redirect_to @book, notice: "Reflection added!"
    else
      redirect_to @book, alert: "Failed to add reflection."
    end
  end

  def destroy
    @reflection = @book.reflections.find(params[:id])
    @reflection.destroy
    redirect_to @book, notice: "Reflection deleted."
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def reflection_params
    params.require(:reflection).permit(:content)
  end
end
