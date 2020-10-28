class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :book_name
      t.integer :books_count

      t.timestamps
    end
  end
end
