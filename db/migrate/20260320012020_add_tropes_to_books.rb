class AddTropesToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :tropes, :text, array: true, default: []
  end
end
