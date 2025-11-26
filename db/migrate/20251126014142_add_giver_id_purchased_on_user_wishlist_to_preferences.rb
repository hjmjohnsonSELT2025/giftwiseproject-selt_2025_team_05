class AddGiverIdPurchasedOnUserWishlistToPreferences < ActiveRecord::Migration[7.1]
  def change
    add_reference :preferences, :users, foreign_key: true, null: true
    add_column :preferences, :purchased?, :boolean
    add_column :preferences, :on_user_wishlist?, :boolean
  end
end
