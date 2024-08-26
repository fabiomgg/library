class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy
end
