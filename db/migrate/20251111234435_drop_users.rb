class DropUsers < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :events, :users
    remove_column :events, :user_id, :integer
    remove_foreign_key :event_users, :users
    remove_column :event_users, :user_id, :integer
    remove_foreign_key :preferences, :users
    remove_column :preferences, :user_id, :integer
    drop_table :users
  end
end
