class CreateBookTropes < ActiveRecord::Migration[8.1]
  def change
    create_table :book_tropes do |t|
      t.references :book, null: false, foreign_key: true
      t.references :trope, null: false, foreign_key: true

      t.timestamps
    end

    add_index :book_tropes, [:book_id, :trope_id], unique: true
  end
end
