# frozen_string_literal: true
class BooksController < ApplicationController
  def add_book
    user = User.find_by(email: params[:email])
    if user.present?
      book = Book.find_by(author: params[:author], title: params[:title], genre: params[:genre])
      if book.present?
        book.change_books_quantity(params[:quantity].nil? ? 1 : params[:quantity])
      else
        book = Book.new(book_params)
        if book.save
          render json: { message: 'Book added' }, status: 200
        else
          render json: { error: 'Book isn`t added' }, status: 400
        end
      end
    else
      render json: { message: 'You have no rights to add a book' }, status: 400
    end
  end

  def find_by_genre
    @books = Book.where('quantity > 0 and genre = ?', params[:genre])
  end

  def book_params
    params.permit(:author, :title, :genre, :quantity).to_h
  end
end
