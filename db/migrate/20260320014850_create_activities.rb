class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action_type
      t.references :trackable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
