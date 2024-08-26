require 'rails_helper'

RSpec.describe "Books API", type: :request do
  let!(:librarian) { create(:user, :librarian) }
  let!(:member) { create(:user) }
  let!(:books) { create_list(:book, 5) }
  let(:book_id) { books.first.id }

  let(:valid_attributes) { { title: 'Learn Elm', author: 'John Doe', genre: 'Programming', total_copies: 3 } }
  let(:librarian_headers) { auth_headers_for(librarian) }
  let(:member_headers) { auth_headers_for(member) }

  describe 'GET /api/v1/books' do
    context 'when the user is a member' do
      before { get '/api/v1/books', headers: member_headers }

      it 'returns all books' do
        expect(json.size).to eq(5)
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user is a librarian' do
      before { get '/api/v1/books', headers: librarian_headers }

      it 'returns all books' do
        expect(json.size).to eq(5)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /api/v1/books/:id' do
    context 'when the user is a member' do
      before { get "/api/v1/books/#{book_id}", headers: member_headers }

      it 'returns the book' do
        expect(json['id']).to eq(book_id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user is a librarian' do
      before { get "/api/v1/books/#{book_id}", headers: librarian_headers }

      it 'returns the book' do
        expect(json['id']).to eq(book_id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when the book does not exist' do
      let(:book_id) { 100 }

      before { get "/api/v1/books/#{book_id}", headers: librarian_headers }

      it 'returns a 404 status' do
        expect(response).to have_http_status(404)
        expect(json['error']).to match(/Book not found/)
      end
    end
  end

  describe 'POST /api/v1/books' do
    context 'when the user is a librarian' do
      before { post '/api/v1/books', params: valid_attributes.to_json, headers: librarian_headers }

      it 'creates a new book' do
        expect(json['title']).to eq('Learn Elm')
        expect(response).to have_http_status(201)
      end
    end

    context 'when the user is a member' do
      before { post '/api/v1/books', params: valid_attributes.to_json, headers: member_headers }

      it 'returns a 403 status' do
        expect(response).to have_http_status(403)
        expect(json['error']).to match(/You are not authorized to perform this action./)
      end
    end
  end

  describe 'PUT /api/v1/books/:id' do
    context 'when the user is a librarian' do
      before { put "/api/v1/books/#{book_id}", params: { title: 'Learn Ruby' }.to_json, headers: librarian_headers }

      it 'updates the book' do
        expect(json['title']).to eq('Learn Ruby')
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user is a member' do
      before { put "/api/v1/books/#{book_id}", params: { title: 'Learn Ruby' }.to_json, headers: member_headers }

      it 'returns a 403 status' do
        expect(response).to have_http_status(403)
        expect(json['error']).to match(/You are not authorized to perform this action./)
      end
    end
  end

  describe 'DELETE /api/v1/books/:id' do
    context 'when the user is a librarian' do
      before { delete "/api/v1/books/#{book_id}", headers: librarian_headers }

      it 'deletes the book' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the user is a member' do
      before { delete "/api/v1/books/#{book_id}", headers: member_headers }

      it 'returns a 403 status' do
        expect(response).to have_http_status(403)
        expect(json['error']).to match(/You are not authorized to perform this action./)
      end
    end
  end

  def auth_headers_for(user)
    {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{jwt_for(user)}"
    }
  end
end
