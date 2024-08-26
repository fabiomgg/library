class BorrowingPolicy < ApplicationPolicy
  def create?
    # Prevent the user from borrowing the same book if they haven't returned it yet
    !user.borrowings.exists?(book: record.book, returned_at: nil)
  end

  def return?
    # Only allow librarians to mark a book as returned
    user.librarian?
  end
end