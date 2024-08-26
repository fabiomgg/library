class BooksController < ApplicationController
  include Pundit::Authorization
  layout 'app'
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
  end

  def show;end

  def new
    @book = Book.new
    authorize(@book)
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize(@book)
  end

  def update
    authorize(@book)
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize(@book)
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully deleted..'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end
end
