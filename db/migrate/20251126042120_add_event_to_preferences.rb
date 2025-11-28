class AddEventToPreferences < ActiveRecord::Migration[7.1]
  def change
    add_reference :preferences, :events, foreign_key: true, null: true
  end
end
