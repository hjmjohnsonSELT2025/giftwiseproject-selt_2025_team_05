class CreatePreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :item_name
      t.decimal :cost
      t.text :notes

      t.timestamps
    end
  end
end
