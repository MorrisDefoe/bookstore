class CreateUsersOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :users_orders do |t|
      t.references :user, index: true
      t.references :book, index: true
      t.column :status, :string, default: 'ordered'

      t.timestamps
    end
  end
end
