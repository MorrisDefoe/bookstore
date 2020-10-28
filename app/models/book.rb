class Book < ActiveRecord::Base
  validates :author, :title, :genre, presence: true
  book = Book.new
  book.quantity = @quantity

  def decrement
    update_column(:quantity, quantity_in_database - 1)
  end

  def change_books_quantity(value)
    update_column(:quantity, quantity_in_database + value)
  end
end
