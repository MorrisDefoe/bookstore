# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BooksController, 'test books_controller' do
  describe 'add_book action' do
    it 'show template if a user doesn`t have rights to add a book' do
      post :add_book, params: {author: 'Nolan', title: 'Kill', genre: 'horror', quantity: 4 != nil ? 4 : 1}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = {message: 'You have no rights to add a book'}
      expect(actual).to eq expected
    end
  end
  describe 'add_book action' do
    it 'show template if a book added' do
      user = User.new(id: 1, email: 'bb.bb@gmail.com', first_name: 'BB', last_name: 'BB', address: 'cc', status: 'admin', created_at: '2020-10-28 12:02:56.000000', updated_at: '2020-10-28 12:02:57.000000')
      post :add_book, params: {email: user.email, author: 'Nolan', title: 'Kill', genre: 'horror', quantity: 4 != nil ? 4 : 1}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = {message: 'Book added'}
      expect(actual).to eq expected
    end
  end
  describe 'find_by_genre' do
    it 'show list of books by genre' do
      get :find_by_genre, params: {genre: 'horror'}
      exp_book = Book.new(id: 1, author: 'Nolan', title: 'Ujas', genre: 'horror', quantity: 5, created_at: '2020-10-28 18:56:41.000000', updated_at: '2020-10-28 18:56:43.000000')
      json = JSON.parse(response.body)
      expect(json).to eq([exp_book.as_json])
    end
  end
end