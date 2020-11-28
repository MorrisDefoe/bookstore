require 'rails_helper'

RSpec.describe "books_controller", type: :request do
  let(:book) { create :book}
  let(:user) { create :user }

  sign_in :user

  describe 'add_book action' do
    it 'show template if a user doesn`t have rights to add a book' do
      post "/api/v1/books/addBook", params: {email: user.email}
      expect(response).to have_http_status(:forbidden)
    end

    it 'show message if a user doesn`t have rights to add a book' do
      post "/api/v1/books/addBook", params: {email: user.email}
      expected = { message: 'You have no rights to add a book' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show template if book added' do
      user.status=('admin')
      post "/api/v1/books/addBook", params: {email: user.email, author: book.author, title: book.title, genre: book.genre, quantity: book.quantity}
      expect(response).to have_http_status(:created)
    end

    it 'show message if book added' do
      user.status=('admin')
      post "/api/v1/books/addBook", params: {email: user.email, author: book.author, title: book.title, genre: book.genre, quantity: book.quantity}
      expected = { message: 'Book added' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show template if book is not added' do
      user.status=('admin')
      post "/api/v1/books/addBook", params: {email: user.email, author: book.author, title: book.title, quantity: book.quantity}
      expect(response).to have_http_status(:bad_request)
    end

    it 'show message if book is not added' do
      user.status=('admin')
      post "/api/v1/books/addBook", params: {email: user.email, author: book.author, title: book.title, quantity: book.quantity}
      expected = { error: 'Book isn`t added' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end
  end
end
