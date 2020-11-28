# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :users_orders
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum status: { admin: 'admin', user: 'user' }
end
