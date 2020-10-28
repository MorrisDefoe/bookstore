require 'rails_helper'

RSpec.describe UsersController, 'test users_controller' do
  describe 'show action' do
    it 'show template if a user is found' do
      get :show, params: {id: 2}
      exp_user = User.new(id: 2, email: "aa.bb@gmail.com", first_name: "AA", last_name: "BB", address: "cc", status: "user", created_at: "2020-10-28 12:02:56", updated_at: "2020-10-28 12:02:57")
      json = JSON.parse(response.body)
      expect(json).to eq(exp_user.as_json)
    end
  end
  describe 'show action user not found' do
    it 'show template if a user is not found' do
      get :show, params: {id: 0}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = {error: 'User not found'}
      expect(actual).to eq expected
    end
  end
  describe 'create action' do
    it 'show template if an user is created' do
      post :create, params: {email: 'aa@test.com', first_name: 'aa', last_name: 'bb', address: 'cc'}
      actual = JSON.parse(response.body, symbolize_names: true)
      expected = {message: 'User created'}
      expect(actual).to eq expected
    end
  end
  describe 'active_users action' do
    it 'show template with list of active users' do
      get :active_users
      exp_user = User.new(id: 2, email: "aa.bb@gmail.com", first_name: "AA", last_name: "BB", address: "cc", status: "user", created_at: "2020-10-28 12:02:56", updated_at: "2020-10-28 12:02:57")
      exp_arr = Array.new
      exp_arr.insert(0,exp_user)
      json = JSON.parse(response.body)
      expect(json).to eq([exp_user.as_json])
    end
  end
end