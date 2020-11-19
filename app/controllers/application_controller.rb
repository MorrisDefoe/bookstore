class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  def find_user
    @user = User.find_by(email: params[:email])
  end
end
