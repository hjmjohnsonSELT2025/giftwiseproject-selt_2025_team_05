class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references 'user'
      t.string 'event_name'
      t.string 'event_date'
      t.boolean 'deleted_from_user_profile'
      t.timestamps
    end
  end
end
