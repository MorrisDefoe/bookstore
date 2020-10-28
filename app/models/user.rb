class User < ApplicationRecord
  has_many :users_orders
  enum status: { admin: 'admin', user: 'user' }
  validates :email, :first_name, :last_name, presence: true
end
