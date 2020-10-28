class MigrationName < ActiveRecord::Migration
  def change
    add_foreign_key :users_orders, :users, column: :user_id, primary_key: "id"
    add_foreign_key :users_orders, :books, column: :book_id, primary_key: "id"
  end
end
