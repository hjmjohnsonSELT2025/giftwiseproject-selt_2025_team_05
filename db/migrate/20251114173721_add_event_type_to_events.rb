class AddEventTypeToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :event_type, :integer, default: 0, null: false
  end
end
