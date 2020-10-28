class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :author
      t.string :title
      t.string :genre
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
