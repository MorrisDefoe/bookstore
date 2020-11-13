require 'rails_helper'

RSpec.describe 'order_controller', type: :request do

  let(:users_order) { create :users_order }
  let(:user) { create :user }
  let(:book) { create :book }

  sign_in :user

  describe 'order_book actions' do
    it 'show template if an order accepted' do
      post "/api/v1/order/orderBook", params: {email:user.email, book_id:book.id}
      expected = { message: 'Order accepted' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show template if a book is out of stock' do
      book.quantity=0
      post "/api/v1/order/orderBook", params: {email: user.email, book_id: book.id}
      expected = { error: 'Out of stock' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show list of users orders' do
      get "/api/v1/order/showOrders", params: {email: user.email, status: 'ordered'}
      expected = {orders: [{email: user.email, first_name: user.first_name, address: user.address, author: book.author,
                            title: book.title, genre: book.genre}.with_indifferent_access]}
      expect(JSON.parse(response.body)).to eq(expected)
    end

  end
end