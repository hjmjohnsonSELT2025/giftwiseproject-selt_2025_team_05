class AddBudgetToEventUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :event_users, :budget, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
