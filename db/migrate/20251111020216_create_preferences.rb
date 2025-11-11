class CreatePreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preferences do |t|
      t.references 'user'
      t.string 'item'
      t.boolean 'like_or_dislike'
      t.timestamps
    end
  end
end
