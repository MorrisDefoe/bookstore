class Book < ActiveRecord::Base
  has_many :users_orders

  validates :author, :title, :genre, presence: true

  def decrease_quantity
    update_column(:quantity, quantity_in_database - 1)
  end

  # def change_books_quantity(value)
  #    update_column(:quantity, self.quantity + value)
  # end
end
