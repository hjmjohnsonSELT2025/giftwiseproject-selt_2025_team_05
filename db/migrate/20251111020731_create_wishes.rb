class CreateWishes < ActiveRecord::Migration[7.1]
  def change
    create_table :wishes do |t|

      t.timestamps
    end
  end
end
