class UserPolicy < ApplicationPolicy
  def add_book?
    user.status == 'admin'
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
