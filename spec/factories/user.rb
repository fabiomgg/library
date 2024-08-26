FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }

    trait :member do
      role { :member }
    end

    trait :librarian do
      role { :librarian }
    end
  end
end
