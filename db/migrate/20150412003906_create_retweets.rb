class CreateRetweets < ActiveRecord::Migration[5.1]
  def change
    create_table :retweets do |t|
      t.integer :user_id
      t.integer :micropost_id

      t.timestamps null: false
    end

    # search for displaying tweet as part of someone's feed
    add_index :retweets, :user_id
    # search for when displaying on OP's page to show list of RTs
    add_index :retweets, :micropost_id

    add_index :retweets, [:user_id, :micropost_id], unique: true
  end
end
