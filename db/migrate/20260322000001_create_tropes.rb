class CreateTropes < ActiveRecord::Migration[8.1]
  def change
    create_table :tropes do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :tropes, :name, unique: true
  end
end
