FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    isbn { Faker::Number.unique.number(digits: 10) }
    total_copies { Faker::Number.between(from: 1, to: 10) }
  end
end
