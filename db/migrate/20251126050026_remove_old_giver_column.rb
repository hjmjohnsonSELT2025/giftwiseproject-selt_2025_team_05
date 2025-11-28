class RemoveOldGiverColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :preferences, :giver_id, :integer
  end
end
