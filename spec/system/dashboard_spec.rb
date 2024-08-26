require 'rails_helper'

RSpec.describe 'Dashboard', type: :system do
  let!(:librarian) { create(:user, :librarian) }
  let!(:member) { create(:user, :member) }
  let!(:book1) { create(:book, title: "Book One", total_copies: 3) }
  let!(:book2) { create(:book, title: "Book Two", total_copies: 3) }

  describe 'Librarian Dashboard' do
    let!(:borrowing1) { create(:borrowing, user: member, book: book1, borrowed_at: 1.week.ago, due_at: Date.today) }
    let!(:borrowing2) { create(:borrowing, user: member, book: book2, borrowed_at: 3.weeks.ago, due_at: 1.week.ago) }
    before do
      login_as(librarian)
      visit(dashboard_path)
    end

    it 'displays total books and total borrowed books' do
      expect(page).to have_content("Total Books: 2")
      expect(page).to have_content("Total Borrowed Books: 2")
    end

    it 'displays a list of members with overdue books' do
      expect(page).to have_content("Members with Overdue Books")
      expect(page).to have_content(member.email)
      expect(page).to have_content("Book Two")
    end
  end

  describe 'Member Dashboard' do
    let!(:borrowing1) { create(:borrowing, user: member, book: book1, borrowed_at: 1.week.ago, due_at: Date.today) }
    let!(:borrowing2) { create(:borrowing, user: member, book: book2, borrowed_at: 3.weeks.ago, due_at: 1.week.ago) }
    before do
      login_as(member)
      visit(dashboard_path)
    end

    it 'displays the books the member has borrowed' do
      expect(page).to have_content("Your Borrowed Books")
      expect(page).to have_content("Book One")
      expect(page).to have_content("Book Two")
    end

    it 'displays the due dates of the borrowed books' do
      expect(page).to have_content("Due Date")
      expect(page).to have_content(Date.today.to_s)
      expect(page).to have_content(1.week.ago.to_date.to_s)
    end

    it 'displays overdue books' do
      expect(page).to have_content("Overdue")
      expect(page).not_to have_content("Book One (Due: #{borrowing1.due_at.to_s})")
      expect(page).to have_content("Book Two (Due: #{borrowing2.due_at.to_s})")
    end
  end
end
