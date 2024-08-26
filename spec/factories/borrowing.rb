FactoryBot.define do
  factory :borrowing do
    association :user
    association :book
    borrowed_at { Time.now }
    due_at { 2.weeks.from_now }
    returned_at { nil }
  end
end
