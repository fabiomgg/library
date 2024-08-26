class BorrowingsController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :set_book, only: [:create, :return]

  def create
    borrowing = current_user.borrowings.new(book: @book, borrowed_at: Time.now, due_at: 2.weeks.from_now)
    authorize borrowing, :create?

    if @book.borrowings.where(returned_at: nil).count < @book.total_copies
      if borrowing.save
        redirect_to @book, notice: 'Book was successfully borrowed.'
      else
        redirect_to @book, notice: 'Unable to borrow the book.'
      end
    else
      redirect_to @book, notice: 'No copies available for borrowing.'
    end
  end

  def return
    borrowing = Borrowing.find(params[:borrowing_id])
    authorize borrowing, :return?
  
    if borrowing.update(returned_at: Time.now)
      redirect_to @book, notice: 'Book was successfully returned.'
    else
      redirect_to @book, notice: 'No active borrowing found for this book.'
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end
end
