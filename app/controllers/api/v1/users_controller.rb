module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, except: :create

      def show
        @user = User.find_by(id: params[:id])
        unless @user.present?
          render json: {error: 'User not found'}, status: 404
        end
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: { message: 'User has been created' }, status: 201
        else
          render json: { error: 'User has not been created' }, status: 400
        end
      end

      def active_users
        @orders = UsersOrder.all.select(:user_id).distinct(:user_id)
      end

      def make_admin
        user = User.find_by(email: params[:email])
        user.status = ('admin')
        user.save
        render json: { message: 'user`s status changed to admin' }, status: 200
      end

      def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :address, :password).to_h
      end
    end
  end
end

