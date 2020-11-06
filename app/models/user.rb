class User < ApplicationRecord

  has_many :users_orders

  enum status: { admin: 'admin', user: 'user' }

  validates :email, :first_name, :last_name, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end
