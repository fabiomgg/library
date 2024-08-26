class User < ApplicationRecord
  enum role: { member: 0, librarian: 1 }
  
  has_many :borrowings, dependent: :destroy
end
