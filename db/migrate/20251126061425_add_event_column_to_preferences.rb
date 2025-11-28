class AddEventColumnToPreferences < ActiveRecord::Migration[7.1]
  def change
    add_reference :preferences, :event, foreign_key: {to_table: :events}, null: true
  end
end
