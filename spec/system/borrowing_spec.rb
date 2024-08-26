require 'rails_helper'

RSpec.describe 'Borrowing and Returning Books', type: :system do
  let!(:librarian) { create(:user, :librarian) }
  let!(:member) { create(:user, :member) }
  let!(:book) { create(:book, total_copies: 3) }

  describe 'Member borrowing a book' do
    before { login_as member }

    it 'allows a member to borrow a book if available' do
      visit book_path(book)

      expect(page).to have_button 'Borrow this Book'

      click_button 'Borrow this Book'

      expect(page).to have_content 'Book was successfully borrowed.'
      expect(page).not_to have_button 'Borrow this Book'
      expect(page).to have_content 'You have already borrowed this book.'
    end

    it 'prevents a member from borrowing a book if no copies are available' do
      create_list(:borrowing, 3, book: book, returned_at: nil)

      visit book_path(book)

      expect(page).to have_content 'No copies available for borrowing.'
      expect(page).not_to have_button 'Borrow this Book'
    end
  end

  describe 'Librarian returning a book' do
    let!(:borrowing) { create(:borrowing, user: member, book: book, returned_at: nil) }

    before { login_as librarian }

    it 'allows a librarian to mark a book as returned' do
      visit book_path(book)

      within('table tbody') do
        expect(page).to have_content member.email
        expect(page).to have_button 'Mark as Returned'
        click_button 'Mark as Returned'
      end

      expect(page).to have_content 'Book was successfully returned.'
      within('table tbody') do
        expect(page).not_to have_content member.email
      end
    end
  end

  describe 'Unauthorized actions' do
    let!(:borrowing) { create(:borrowing, user: member, book: book, returned_at: nil) }

    it 'prevents a member from marking a book as returned' do
      login_as member
      visit book_path(book)

      expect(page).not_to have_button 'Mark as Returned'
    end
  end
end
