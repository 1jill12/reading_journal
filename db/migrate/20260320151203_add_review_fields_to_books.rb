class AddReviewFieldsToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :format, :string
    add_column :books, :spice_rating, :integer
    add_column :books, :sadness_rating, :integer
    add_column :books, :humor_rating, :integer
    add_column :books, :suspense_rating, :integer
  end
end
