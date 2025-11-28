class RemoveOldEventIdColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :preferences, :events_id, :integer
  end
end
