class CreateFriendship < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.references :user, null: false
      t.references :friend, null: false, foreign_key: {to_table: :users}
      t.string :status
      t.timestamps
    end
  end
end
