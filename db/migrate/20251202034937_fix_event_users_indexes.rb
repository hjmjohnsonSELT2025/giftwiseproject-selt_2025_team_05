class FixEventUsersIndexes < ActiveRecord::Migration[7.1]
  def change
    # Drop any existing indexes that might be wrong (prev migrations- bug mentioned in teams chat)
    remove_index :event_users, name: "index_event_users_on_event_id_and_user_id", if_exists: true
    remove_index :event_users, name: "index_event_users_on_event_id", if_exists: true
    remove_index :event_users, name: "index_event_users_on_user_id", if_exists: true

    # Ensure user_id is NOT NULL
    change_column_null :event_users, :user_id, false

    # Recreate the proper indexes
    add_index :event_users, :event_id
    add_index :event_users, :user_id
    add_index :event_users, [:event_id, :user_id], unique: true
  end
end