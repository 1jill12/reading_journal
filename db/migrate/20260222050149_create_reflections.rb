class CreateReflections < ActiveRecord::Migration[8.1]
  def change
    create_table :reflections do |t|
      t.references :book, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
