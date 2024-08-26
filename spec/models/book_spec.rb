require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:borrowings).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_numericality_of(:total_copies).is_greater_than_or_equal_to(0) }
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

  describe '#available_copies' do
    let(:book) { create(:book, total_copies: 5) }

    subject { book.available_copies }

    context 'when no copies are borrowed' do
      it { is_expected.to eq(5) }
    end

    context 'when some copies are borrowed' do
      before do
        create_list(:borrowing, 2, book: book, returned_at: nil)
      end

      it { is_expected.to eq(3) }
    end

    context 'when all copies are borrowed' do
      before do
        create_list(:borrowing, 5, book: book, returned_at: nil)
      end

      it { is_expected.to eq(0) }
    end

    context 'when some copies are returned' do
      before do
        create(:borrowing, book: book, returned_at: nil)
        create(:borrowing, book: book, returned_at: 1.day.ago) # returned borrowing
      end

      it { is_expected.to eq(4) }
    end
  end
end
