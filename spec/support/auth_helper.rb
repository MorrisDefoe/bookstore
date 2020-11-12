# frozen_string_literal: true

module AuthHelper
  def auth_headers(user)
    user.create_new_auth_token
  end

  def combined_auth_headers(user)
    return nil if user.nil?

    user.save
    user.create_new_auth_token(user.tokens.keys.first)
  end
end