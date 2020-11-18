class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def find_user
    @user = User.find_by(email: params[:email])
  end
end
