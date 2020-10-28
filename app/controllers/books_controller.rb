class BooksController < ApplicationController
  def add_book
    @user = User.find_by_sql ["select * from users where email = ? and users.status = 'admin'", params[:email]]
    if @user.count != 0
      @books = Book.find_by_sql ['select * from books where author = ? and title = ? and genre = ?', params[:author], params[:title], params[:genre]]
      if !@books.empty?
        @books[0].change_books_quantity(params[:quantity])
      else
        @book = Book.new(author: params[:author], title: params[:title], genre: params[:genre], quantity: params[:quantity] != nil ? params[:quantity] : 1)
        @book.save
        render json: {
            message: 'Book added'
        }, status: 200
      end
    else
      render json: {
          message: 'You have no rights to add a book'
      }, status: 400
    end
  end

  def find_by_genre
    @book = Book.find_by_sql ['select * from books where genre = ? and books.quantity > 0', params[:genre]]
    render json: @book
  end
end

