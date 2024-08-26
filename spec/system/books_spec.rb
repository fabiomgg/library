# spec/system/books_spec.rb
require 'rails_helper'

RSpec.describe 'Books', type: :system do
  let!(:librarian) { create(:user, :librarian) }
  let!(:member) { create(:user, :member) }
  let!(:book) { create(:book) }

  context 'searching' do
    it 'shows books that match the search term in title' do
      login_as member
      visit books_path

      fill_in 'Search', with: book.title
      click_button 'Search'

      expect(page).to have_content(book.title)
    end
  end

  context 'as a librarian' do
    before { login_as(librarian) }

    describe 'Creating a Book' do
      it 'allows librarian to create a book' do
        visit new_book_path

        fill_in 'Title', with: 'New Book Title'
        fill_in 'Total copies', with: '5'
        click_button 'Create Book'

        expect(page).to have_content('Book was successfully created.')
        expect(page).to have_content('New Book Title')
      end

      it 'does not allow creating a book without a title' do
        visit new_book_path

        fill_in 'Title', with: ''
        click_button 'Create Book'

        expect(page).to have_content("Title can't be blank")
      end
    end

    describe 'Viewing a Book' do
      it 'allows librarian to view a book' do
        visit book_path(book)

        expect(page).to have_content(book.title)
        expect(page).to have_content(book.author)
      end
    end

    describe 'Editing a Book' do
      it 'allows librarian to edit a book' do
        visit edit_book_path(book)

        fill_in 'Title', with: 'Updated Book Title'
        click_button 'Update Book'

        expect(page).to have_content('Book was successfully updated.')
        expect(page).to have_content('Updated Book Title')
      end

      it 'does not allow updating a book without a title' do
        visit edit_book_path(book)

        fill_in 'Title', with: ''
        click_button 'Update Book'

        expect(page).to have_content("Title can't be blank")
      end
    end

    describe 'Deleting a Book', js: true do
      it 'allows librarian to delete a book' do
        visit book_path(book)

        expect { click_link 'Delete'; sleep 1 }.to change{Book.count}.by(-1)
        expect(page).to have_content('Book was successfully deleted.')
      end
    end
  end

  context 'as a member' do
    before { login_as(member) }

    describe 'Access Control' do
      it 'prevents member from accessing book creation or edit features' do
        visit books_path
        expect(page).not_to have_link('New Book')

        visit book_path(book)
        expect(page).not_to have_link('Edit')
        expect(page).not_to have_link('Destroy')
      end

      it 'redirects to root or shows an authorization error when trying to access the new book path' do
        visit new_book_path

        expect(page).to have_content('You are not authorized to view this page.') # or expect to be redirected
      end
    end

    describe 'Viewing a Book' do
      it 'allows member to view a book' do
        visit book_path(book)

        expect(page).to have_content(book.title)
      end
    end
  end
end
