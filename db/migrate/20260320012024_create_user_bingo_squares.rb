class CreateUserBingoSquares < ActiveRecord::Migration[8.1]
  def change
    create_table :user_bingo_squares do |t|
      t.references :user_bingo_card, null: false, foreign_key: true
      t.references :bingo_square, null: false, foreign_key: true
      t.references :book, null: true, foreign_key: true

      t.timestamps
    end
  end
end
