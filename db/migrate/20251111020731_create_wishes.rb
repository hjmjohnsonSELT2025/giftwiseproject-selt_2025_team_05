class CreateWishes < ActiveRecord::Migration[7.1]
  def change
    create_table :wishes do |t|
      t.references 'user'
      t.string 'item_name'
      t.decimal 'price'
      t.string 'link'
      t.string 'note'
      t.timestamps
    end
  end
end
