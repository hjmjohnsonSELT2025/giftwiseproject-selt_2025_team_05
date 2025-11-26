class RenameUsersIdColumnToGiverId < ActiveRecord::Migration[7.1]
  def change
    rename_column :preferences, :users_id, :giver_id
  end
end
