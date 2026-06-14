class CreateBingoCards < ActiveRecord::Migration[8.1]
  def change
    create_table :bingo_cards do |t|
      t.string :title
      t.text :description
      t.string :theme

      t.timestamps
    end
  end
end
