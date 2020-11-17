class Book < ActiveRecord::Base
  has_many :users_orders

  validates :author, :title, :genre, presence: true

  validates_numericality_of :quantity, :greater_than => 0

end
