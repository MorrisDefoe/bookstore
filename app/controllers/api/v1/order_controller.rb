module Api
  module V1
    class OrderController < ApplicationController
      before_action :authenticate_user!

      def order_book
        book = Book.find_by(id: params[:book_id])
        if book.present? && book.quantity.positive?
          UsersOrder.create(user_id: current_user.id, book_id: book.id)
          book.quantity-=1
          book.save
          render json: { message: 'Order accepted' }, status: 201
        else
          render json: { error: 'Out of stock' }, status: 400
        end
      end

      def show_orders
        user = User.find_by(email: params[:email])
        if user.present?
          @orders = UsersOrder.joins(:user, :book).where(status: params[:status]).order('created_at ASC')
        else
          render json: { error: 'User not found' }, status: 404
        end
      end

      def change_status
        user = User.find_by(email: params[:email])
        if user.present?
          order = UsersOrder.find_by(id: params[:order_id])
          order.change_status
          render json: { message: 'Status changed to delivered' }, status: 200
        else
          render json: { error: 'User not found' }, status: 404
        end
      end
    end
  end
end

