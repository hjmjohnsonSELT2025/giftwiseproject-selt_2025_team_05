Given("I am a user logged in") do
  @user = User.create!(email: "test@example.com", password: "password")
  visit new_user_session_path
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "password"
  click_button "Sign in"
end

Given("{string} has added an item named {string} to their wish list") do |user_name, item_name|
  user = User.find_by!(first_name: user_name)
  user.preferences.create!(
    item_name: item_name,
    cost: 10,
    notes: "Item details",
    on_user_wishlist: true
  )
end

When("I visit the wishlist page") do
  visit preferences_path
end

