class AddStatusToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :status, :string, default: 'user'
  end
end
