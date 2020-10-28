require 'rails_helper'

RSpec.describe OrderController, 'test order_controller' do
  describe 'order_book action order accepted' do
    it 'show template if an order accepted' do
      post :order_book, params: {email: 'aa.bb@gmail.com', book_id: '1'}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = { message: 'Order accepted' }
      expect(actual).to eq expected
    end
    end
  describe 'order_book action book out of stock' do
    it 'show template if an order accepted' do
      post :order_book, params: {email: 'aa.bb@gmail.com', book_id: '2'}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = { error: 'Out of stock' }
      expect(actual).to eq expected
    end
  end
  describe 'order_book action wrong data' do
    it 'show template if user enters wrong email' do
      post :order_book, params: {email: 'aaaa.bb@gmail.com', book_id: '2'}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = { error: 'Wrong data' }
      expect(actual).to eq expected
    end
  end
  describe 'order_book action wrong data' do
    it 'show template if user enters id of book which does not exist' do
      post :order_book, params: {email: 'aaaa.bb@gmail.com', book_id: '0'}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = { error: 'Wrong data' }
      expect(actual).to eq expected
    end
  end
  describe 'show_orders' do
    it 'show list of users orders' do
      get :show_orders, params: {email: 'bb.bb@gmail.com', status: 'ordered'}
      actual = JSON.parse(response.body)
      expected = UsersOrder.find_by_sql ["select users_orders.id, users.email, books.title, books.genre from users_orders
      LEFT JOIN users ON users_orders.user_id = users.id
      LEFT JOIN books ON users_orders.book_id = books.id where users_orders.status = 'ordered' ORDER BY users_orders.created_at ASC"]
      expect(actual).to eq (expected.as_json)
    end
  end
  describe 'change_status' do
    it 'show template if admin has changed status from "ordered" to "delivered"' do
      put :change_status, params: {email: 'bb.bb@gmail.com', order_id: 1}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = { message: 'Status changed to delivered' }
      expect(actual).to eq expected
    end

  end
end