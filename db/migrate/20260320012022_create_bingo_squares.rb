class CreateBingoSquares < ActiveRecord::Migration[8.1]
  def change
    create_table :bingo_squares do |t|
      t.references :bingo_card, null: false, foreign_key: true
      t.string :trope_name
      t.integer :position
      t.boolean :free_space

      t.timestamps
    end
  end
end
