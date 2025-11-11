class CreateUsersevents < ActiveRecord::Migration[7.1]
  def change
    create_table :users_events, :id => false  do |t|
      t.references :user, null: false
      t.references :event, null: false
      t.string 'status', null: false
      t.timestamps
    end
  end
end
