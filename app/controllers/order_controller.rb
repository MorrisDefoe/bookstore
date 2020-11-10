class OrderController < ApplicationController

  def order_book
    user = User.find_by(email: params[:email])
    book = Book.find_by(id: params[:book_id])
    if book.present? && user.present? && book.quantity.positive?
      UsersOrder.create(user_id: user.id, book_id: book.id)
      book.decrease_quantity
      render json: { message: 'Order accepted' }, status: 200

    else
      render json: { error: 'Out of stock' }, status: 400
    end
  end

  # params: email(admin?), status, sort by created_at
  def show_orders
    user = User.find_by(email: params[:email])
    if user.present?
      @orders = UsersOrder.joins(:user, :book).where(status: params[:status]).order('created_at ASC')
    else
      render json: { error: 'User not found' }, status: 400
    end
  end

  def change_status
    user = User.find_by(email: params[:email])
    if user.present?
      order = UsersOrder.find_by(id: params[:order_id])
      order.change_status
      render json: { message: 'Status changed to delivered' }, status: 200
    else
      render json: { error: 'User not found' }, status: 400
    end
  end
end
