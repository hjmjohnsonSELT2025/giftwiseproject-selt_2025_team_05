class AddUniqueIndexToEventsOnNameAndUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :events, :user, foreign_key: true
    add_reference :event_users, :user, foreign_key: true
    add_reference :preferences, :user, foreign_key: true
    add_index :events, [:user_id, :name], unique: true
  end
end
