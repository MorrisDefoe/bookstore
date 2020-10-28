class OrderController < ApplicationController

  def order_book
    begin
      @user = User.where('email = ?', params[:email])[0].id_in_database
      @book = Book.where('id = ?', params[:book_id])
      if !@book.nil? && !@user.nil? && @book[0].quantity_in_database > 0
        UsersOrder.create(user_id: @user, book_id: @book[0].id_in_database)
        @book[0].decrement

        render json: {
          message: 'Order accepted'
        }, status: 200

      else
        render json: {
          error: 'Out of stock'
        }, status: 400
      end
    rescue NoMethodError
      render json: {
        error: 'Wrong data'
      }, status: 400
    end
  end

  # params: email(admin?), status(sort by status)
  def show_orders
    @user = User.find_by_sql ["select * from users where email = ? and users.status = 'admin'", params[:email]]
    if @user.count != 0
      @orders = UsersOrder.find_by_sql ["select users_orders.id, users.email, books.title, books.genre from users_orders
      LEFT JOIN users ON users_orders.user_id = users.id
      LEFT JOIN books ON users_orders.book_id = books.id where users_orders.status = ? ORDER BY users_orders.created_at ASC", params[:status]]
    end
    render json: @orders
  end

  def change_status
    @user = User.find_by_sql ["select * from users where email = ? and users.status = 'admin'", params[:email]]
    if @user.count != 0
      @order = UsersOrder.where('id = ?', params[:order_id])
      @order[0].change_status
      render json: {
        message: 'Status changed to delivered'
      }, status: 200
    end
  end
end