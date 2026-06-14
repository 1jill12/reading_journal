class CreateReadingGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :goal_type,         null: false
      t.string  :title
      t.integer :target,            null: false
      t.integer :year
      t.integer :month
      t.integer :current_progress,  null: false, default: 0
      t.string  :status,            null: false, default: 'active'
      t.datetime :completed_at

      t.timestamps
    end
    add_index :reading_goals, [:user_id, :status]
  end
end
