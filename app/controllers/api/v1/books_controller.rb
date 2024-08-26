module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: [:show, :update, :destroy]

      def index
        @books = Book.all
        render json: @books, status: :ok
      end

      def show
        render json: @book, status: :ok
      end

      def create
        @book = Book.new(book_params)
        authorize @book
        if @book.save
          render json: @book, status: :created
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @book
        if @book.update(book_params)
          render json: @book, status: :ok
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @book
        @book.destroy
        head :no_content
      end

      private

      def book_params
        params.require(:book).permit(:title, :author, :genre, :total_copies)
      end

      def set_book
        @book = Book.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Book not found' }, status: :not_found
      end
    end
  end
end
