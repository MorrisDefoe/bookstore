class Store < ActiveRecord::Base
  has_many :books

  validates :book_name, :books_count, presence: true
end
