class ConvertSuggestionsInPreferencesToSuggestionsObjects < ActiveRecord::Migration[7.1]
  def change
    Preference.all.each do |preference|
      if !(preference.on_user_wishlist)
        #make new suggestion
        Suggestion.create!(user: preference.giver,
                           item_name: preference.item_name,
                           cost: preference.cost,
                           notes: preference.notes,
                           purchased: preference.purchased,
                           event: preference.event,
                           recipient: preference.user)
        preference.destroy!
      end
    end
    remove_column 'preferences', 'on_user_wishlist'
  end
end
