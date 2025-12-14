class AddNotNullConstraintToEventsDate < ActiveRecord::Migration[7.1]
  def up
    # Update any existing null dates to current time before adding constraint
    execute "UPDATE events SET date = datetime('now') WHERE date IS NULL"
    change_column_null :events, :date, false
  end

  def down
    change_column_null :events, :date, true
  end
end
