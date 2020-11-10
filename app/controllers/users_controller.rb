class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    unless @user.present?
      render json: {error: 'User not found'}
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User has been created' }, status: 200
    else
      render json: { error: 'User has not been created' }, status: 400
    end
  end

  def active_users
    @users = UsersOrder.select(:user_id).distinct
  end

  def make_admin
    user = User.find_by(email: params[:email])
    user.status = ('admin')
    user.save
    render json: { message: 'user`s status changed to admin' }, status: 200
  end

  def user_params
    params.permit(:email, :first_name, :last_name, :address).to_h
  end
end
