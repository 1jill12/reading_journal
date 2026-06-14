class CreateAzChallengeEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :az_challenge_entries do |t|
      t.bigint :user_id, null: false
      t.string :letter, null: false
      t.bigint :book_id
      t.string :custom_title
      t.integer :year, null: false

      t.timestamps
    end

    add_index :az_challenge_entries, [:user_id, :letter, :year], unique: true
    add_index :az_challenge_entries, :book_id
  end
end
