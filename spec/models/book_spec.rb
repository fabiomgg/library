require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:borrowings).dependent(:destroy) }
  end

  describe '.search' do
    let!(:book1) { create(:book, title: "The Great Gatsby", author: "F. Scott Fitzgerald", genre: "Fiction") }
    let!(:book2) { create(:book, title: "Gatsby's Girl", author: "Caroline Preston", genre: "Historical Fiction") }
    let!(:book3) { create(:book, title: "The Science of Cooking", author: "Dr. Stuart Farrimond", genre: "Drama") }

    context 'with a matching search term' do
      it 'returns books that match the search term in title' do
        expect(Book.search("Gatsby")).to contain_exactly(book1, book2)
      end

      it 'returns books that match the search term in author' do
        expect(Book.search("Fitzgerald")).to contain_exactly(book1)
      end

      it 'returns books that match the search term in genre' do
        expect(Book.search("Fiction")).to contain_exactly(book1, book2)
      end
    end

    context 'with no search term' do
      it 'returns all books' do
        expect(Book.search(nil)).to contain_exactly(book1, book2, book3)
      end
    end

    context 'with an empty search term' do
      it 'returns all books' do
        expect(Book.search("")).to contain_exactly(book1, book2, book3)
      end
    end
  end
end
