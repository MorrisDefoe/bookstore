class User < ApplicationRecord
  enum status: { admin: 'admin', user: 'user' }
  validates :email, :first_name, :last_name, presence: true
end
