class UsersOrder < ActiveRecord::Base

  belongs_to :user
  belongs_to :book

  enum status: { ordered: 'ordered', delivered: 'delivered' }

  validates :user_id, :book_id, presence: true

  def change_status
    update_column(:status, 'delivered')
  end
end