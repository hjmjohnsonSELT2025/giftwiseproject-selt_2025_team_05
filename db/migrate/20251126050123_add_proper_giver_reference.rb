class AddProperGiverReference < ActiveRecord::Migration[7.1]
  def change
    add_reference :preferences, :giver, foreign_key: {to_table: :users}, null: true
  end
end
