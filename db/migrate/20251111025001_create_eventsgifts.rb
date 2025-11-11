class CreateEventsgifts < ActiveRecord::Migration[7.1]
  def change
    create_table :eventsgifts do |t|
      t.references :gifts
      t.references :events
    end
  end
end
