# frozen_string_literal: true
module Api
  module V1
    class BooksController < ApplicationController
      before_action :authenticate_user!
      # before_action :check_user_status, only: [:add_book]

      def add_book
        authorize current_user
        book = Book.find_by(author: params[:author], title: params[:title], genre: params[:genre])
        if book.present?
          quantity = params[:quantity] ? params[:quantity].to_i : 1
          book.quantity += quantity
          book.save
          render json: {message: I18n.t('book.added')}, status: 201
        else
          book = Book.new(book_params)
          if book.save
            render json: {message: I18n.t('book.added')}, status: 201
          else
            render json: {error: I18n.t('book.not_added')}, status: 400
          end
        end
      end

      def find_by_genre
        @books = Book.where('quantity > 0 and genre = ?', params[:genre])
      end

      def book_params
        params.permit(:author, :title, :genre, :quantity).to_h
      end

      # def check_user_status
      #   return if current_user.status == 'admin'
      #
      #   render json: {message: I18n.t('user.access_denied')}, status: 403
      # end
    end
  end
end
