module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, except: :create
      before_action :find_user,only: [:make_admin]

      def show
        @user = User.find_by(id: params[:id])
        unless @user.present?
          render json: {error: I18n.t('user.user_not_found')}, status: 404
        end
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: { message: I18n.t('user.created') }, status: 201
        else
          render json: { error: I18n.t('user.not_created') }, status: 400
        end
      end

      def active_users
        @orders = UsersOrder.all.select(:user_id).distinct(:user_id)
      end

      def make_admin
        @user.status = 'admin'
        @user.save
        render json: { message: I18n.t('user.change_user_status') }, status: 200
      end

      def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :address, :password).to_h
      end
    end
  end
end
