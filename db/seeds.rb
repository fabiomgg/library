# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

FactoryBot.create(:user, :member, email: 'member1@email.com', password: 'password_member1')
FactoryBot.create(:user, :member, email: 'member2@email.com', password: 'password_member2')
FactoryBot.create(:user, :librarian, email: 'librarian@email.com', password: 'password_librarian')

10.times do
  FactoryBot.create(:book)
end
