class CreateGifts < ActiveRecord::Migration[7.1]
  def change
    create_table :gifts do |t|
      t.references :recipient, null: false, foreign_key: {to_table: :users}
      t.references :giver, foreign_key: {to_table: :users}
      t.string 'item_name', null: false
      t.decimal 'item_price'
      t.string 'item_link'
      t.boolean 'on_recipient_wishlist'
      t.boolean 'purchased'
      t.boolean 'active'
      t.timestamps
    end
  end
end
