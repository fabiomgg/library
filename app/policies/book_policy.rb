class BookPolicy < ApplicationPolicy
  attr_reader :user, :post

  def new?
    user.librarian?
  end

  def edit?
    user.librarian?
  end

  def create?
    user.librarian?
  end

  def update?
    user.librarian?
  end

  def destroy?
    user.librarian?
  end
end
