class UsersController < ApplicationController
  def show
    @user = User.where(id: params[:id]).first
    if @user != nil
      render json: @user
    else
      render json: {
      error: 'User not found'
      }
    end
  end

  def create
    @user = User.new(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], address: params[:address])
    @user.save
    render json: {
        message: 'User created'
    }, status: 200
  end

  def active_users
    @user = User.find_by_sql ['select * from users where id IN (select distinct user_id from users_orders)']
    render json: @user
  end
end
