class AddReadingGoalToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :reading_goal, :integer
  end
end
