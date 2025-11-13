class CreateEventUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :event_users do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :event_users, [ :event_id, :user_id ], unique: true
  end
end
