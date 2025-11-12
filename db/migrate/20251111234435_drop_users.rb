class DropUsers < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :events, :users
    remove_foreign_key :event_users, :users
    remove_foreign_key :preferences, :users
    drop_table :users
  end
end
