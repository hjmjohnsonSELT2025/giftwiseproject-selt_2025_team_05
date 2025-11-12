class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :date
      t.string :address
      t.text :description
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
