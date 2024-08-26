class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy

  validates :title, presence: true
  validates :total_copies, numericality: { greater_than_or_equal_to: 0 }

  scope :search, ->(term) {
    where("title LIKE :term OR author LIKE :term OR genre LIKE :term", term: "%#{term}%") if term.present?
  }
end
