class AddNotNullConstraintToEventsDate < ActiveRecord::Migration[7.1]
  def up
    # Update any existing null dates to current time before adding constraint
    Event.where(date: nil).update_all(date: Time.current)
    change_column_null :events, :date, false
  end

  def down
    change_column_null :events, :date, true
  end
end
