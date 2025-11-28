class RenameOnUserWishlistColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :preferences, :on_user_wishlist?, :on_user_wishlist
    rename_column :preferences, :purchased?, :purchased
  end
end
