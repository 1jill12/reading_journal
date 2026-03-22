class RemoveTropesFromBooks < ActiveRecord::Migration[8.1]
  def up
    remove_column :books, :tropes
  end

  def down
    add_column :books, :tropes, :text, array: true, default: []
  end
end
