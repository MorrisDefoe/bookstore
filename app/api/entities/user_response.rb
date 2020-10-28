module BookstoreApi
  module Entities
    class UserResponse < Grape::Entity
      root 'users', 'user'
      format_with(:iso_timestamp) { |dt| dt.to_i }
      expose :id
      expose :first_name
      expose :last_name
      expose :address

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end