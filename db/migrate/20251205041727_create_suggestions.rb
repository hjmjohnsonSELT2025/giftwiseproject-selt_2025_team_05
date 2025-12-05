class CreateSuggestions < ActiveRecord::Migration[7.1]
  def change
    create_table :suggestions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :item_name
      t.decimal :cost
      t.text :notes
      t.boolean "purchased"
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :event, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
