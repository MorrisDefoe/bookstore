class MigrationName < ActiveRecord::Migration
  def change
    add_foreign_key :users_orders, :books
    add_foreign_key :users_orders, :users
  end
end
