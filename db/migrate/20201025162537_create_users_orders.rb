class CreateUsersOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :users_orders do |t|
      t.integer :user_id
      t.integer :book_id
      t.column :status, :string , default: 'ordered'

      t.timestamps
    end
  end
end
