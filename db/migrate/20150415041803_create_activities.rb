class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.integer :subject_id, null: false
      t.string :subject_type, null: false

      t.integer :user_id, null: false
      t.timestamps null: false
    end
    add_index :activities, :subject_id
    add_index :activities, :subject_type
    add_index :activities, :user_id
  end
end
