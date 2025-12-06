class FixEventForeignKeyOnSuggestions < ActiveRecord::Migration[7.1]
  def change
    remove_reference :suggestions, :event, foreign_key: { to_table: :users }
    add_reference :suggestions, :event, foreign_key: {to_table: :events}
  end
end
