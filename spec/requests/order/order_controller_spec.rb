require 'rails_helper'

RSpec.describe 'order_controller', type: :request do

  let(:user) { create :user,:with_order }
  let(:book) { create :book }

  sign_in :user

  describe 'order_book actions' do
    let(:book) { user.users_orders.first.book }

    it 'show message if an order accepted' do
      post "/api/v1/order/orderBook", params: {email:user.email, book_id:book.id}
      expected = { message: 'Order accepted' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show template if an order accepted' do
      post "/api/v1/order/orderBook", params: {email:user.email, book_id:book.id}
      expect(response).to have_http_status(:created)
    end

    it 'show template if a book is out of stock' do
      book.quantity=0
      post "/api/v1/order/orderBook", params: {email: user.email, book: book}
      expected = { error: 'Out of stock' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show template if a book is out of stock' do
      book.quantity=0
      post "/api/v1/order/orderBook", params: {email: user.email, book: book}
      expect(response).to have_http_status(:bad_request)
    end

    it 'show list of users orders' do
      get "/api/v1/order/showOrders", params: {email: user.email, status: 'ordered'}
      expected = {orders: [{email: user.email, first_name: user.first_name, address: user.address, author: book.author,
                            title: book.title , genre: book.genre}]}.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show template of user`s show orders method' do
      get "/api/v1/order/showOrders", params: {email: 'bbbb@bbb.com', status: 'ordered'}
      expect(response).to have_http_status(:not_found)
    end

    it 'show template if admin has changed status from "ordered" to "delivered"' do
      put "/api/v1/order/changeStatus", params: {email: user.email, order_id: user.users_orders.first.id}
      expected = { message: 'Status changed to delivered' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show status if admin has changed status from "ordered" to "delivered"' do
      put "/api/v1/order/changeStatus", params: {email: user.email, order_id: user.users_orders.first.id}
      expect(response).to have_http_status(:ok)
    end

    it 'show status if order status has not been changed' do
      put "/api/v1/order/changeStatus", params: {email: 'bbbb@bbb.com', order_id: user.users_orders.first.id}
      expect(response).to have_http_status(:not_found)
    end
  end
end
