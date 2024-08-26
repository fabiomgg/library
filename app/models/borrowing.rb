class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  scope :not_returned, -> { where(returned_at: nil) }
  scope :overdue, -> { where('due_at < ? AND returned_at IS NULL', Date.today) }
end
