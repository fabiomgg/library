class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum role: { member: 0, librarian: 1 }
  
  has_many :borrowings, dependent: :destroy

  scope :with_overdue_books, -> { joins(:borrowings).merge(Borrowing.overdue).distinct }

  def borrowed_books
    borrowings.not_returned.includes(:book)
  end

  def overdue_books
    borrowings.overdue.includes(:book)
  end
end
