class UsersOrder < ActiveRecord::Base
  enum status: {ordered: 'ordered', delivered: 'delivered' }
  validates :user_id, :book_id, presence: true
  attr_accessor :status

  order = UsersOrder.new
  order.status = @status

  def change_status
    update_column(:status, 'delivered')
  end
end