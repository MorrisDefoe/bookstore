require "rails_helper"

RSpec.describe "users_controller", type: :request do
  let(:user) { create :user }
  let(:book) { create :book }
  sign_in :user

  describe 'show action' do
    it 'show template if a user is found' do
      get "/api/v1/users/#{user.id}/show"
      expect(response).to have_http_status(:ok)
    end

    it 'show template if a user is found' do
      get "/api/v1/users/#{user.id}/show"
      expected = {email: user.email, first_name: user.first_name, last_name: user.last_name, address: user.address}.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'show template if a user is not found' do
      get "/api/v1/users/1111/show"
      expect(response).to have_http_status(:not_found)
    end

    it 'show message if a user is not found' do
      get "/api/v1/users/1111/show"
      expected = {error: 'User not found'}.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end
  end

  describe 'create action' do
    it 'show template if an user is created' do
      post "/api/v1/users/create", params: {user: {email: 'aa@test.com', first_name: 'aa', last_name: 'bb', address: 'cc', password: '123456'}}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = {message: 'User has been created'}
      expect(actual).to eq expected
    end

    it 'show template if an user has not been created' do
      post "/api/v1/users/create", params: {user: {email: 'aa@test.com', first_name: 'aa', last_name: 'bb', address: 'cc'}}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = {error: 'User has not been created'}
      expect(actual).to eq expected
    end
  end

  describe 'active users' do

    before do
      UsersOrder.create(user:user, book:book)
    end
    it 'show template of active users' do
      get "/api/v1/users/active_users"
      expected = {users:[{email: user.email, first_name: user.first_name, address: user.address}]}.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end
  end

  describe 'make admin' do
    it 'show template if user has changed to admin' do
      put "/api/v1/users/makeAdmin", params: {email: user.email}
      expect(response).to have_http_status(:ok)
    end

    it 'show message if user has changed to admin' do
      put "/api/v1/users/makeAdmin", params: {email: user.email}
      expected = { message: 'user`s status changed to admin' }.with_indifferent_access
      expect(JSON.parse(response.body)).to eq(expected)
    end
  end
end