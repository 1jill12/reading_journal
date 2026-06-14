class AddReadingDatesToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :started_at, :datetime
    add_column :books, :finished_at, :datetime
  end
end
