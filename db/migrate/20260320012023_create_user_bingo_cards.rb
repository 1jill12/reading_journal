class CreateUserBingoCards < ActiveRecord::Migration[8.1]
  def change
    create_table :user_bingo_cards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bingo_card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
