class AddUniqueIndexToEventsOnNameAndUser < ActiveRecord::Migration[7.1]
  def change
    add_index :events, [ :user_id, :name ], unique: true
  end
end
