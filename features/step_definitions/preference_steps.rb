Given("I am a user logged in") do
  @user = User.create!(email: "test@example.com", password: "password")
  visit new_user_session_path
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "password"
  click_button "Sign in"
end

When("I visit the wishlist page") do
  visit preferences_path
end

