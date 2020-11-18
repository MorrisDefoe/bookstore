module Api
  module V1
    class OrderController < ApplicationController
      before_action :authenticate_user!
      before_action :find_user, only: [:show_orders, :change_status]

      def order_book
        book = Book.find_by(id: params[:book_id])
        if book.present? && book.quantity.positive?
          UsersOrder.create(user_id: current_user.id, book_id: book.id)
          book.quantity-=1
          book.save
          render json: { message: I18n.t('order.accepted') }, status: 201
        else
          render json: { error: I18n.t('order.out_of_stock') }, status: 400
        end
      end

      def show_orders
        if @user.present?
          @orders = UsersOrder.joins(:user, :book).where(status: params[:status]).order('created_at ASC')
        else
          render json: { error: I18n.t('user.user_not_found') }, status: 404
        end
      end

      def change_status
        if @user.present?
          order = UsersOrder.find_by(id: params[:order_id])
          order.status= 'delivered'
          order.save
          render json: { message: I18n.t('order.change_order_status') }, status: 200
        else
          render json: { error: I18n.t('user.user_not_found') }, status: 404
        end
      end
    end
  end
end
