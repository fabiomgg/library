class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy

  validates :title, presence: true
  validates :total_copies, numericality: { greater_than_or_equal_to: 0 }
end
