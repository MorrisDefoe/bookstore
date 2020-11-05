class Book < ActiveRecord::Base
  has_many :users_orders
  validates :author, :title, :genre, presence: true

  def decrement
    update_column(:quantity, quantity_in_database - 1)
  end

  def change_books_quantity(value)
    update_column(:quantity, quantity_in_database + value)
  end
end
