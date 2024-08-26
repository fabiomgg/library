class DashboardController < ApplicationController
  layout 'app'
  before_action :authenticate_user!

  def show
    current_user.librarian? ? set_librarian_dashboard : set_member_dashboard
  end

  private

  def set_librarian_dashboard
    @total_books = Book.count
    @total_borrowed_books = Borrowing.not_returned.count
    @books_due_today = Book.due_today
    @overdue_members = User.with_overdue_books
    render :librarian
  end

  def set_member_dashboard
    @borrowed_books = current_user.borrowed_books
    @overdue_books = current_user.overdue_books
    render :member
  end
end
