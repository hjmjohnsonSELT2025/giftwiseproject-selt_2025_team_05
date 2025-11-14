Given("I am logged in as a user") do
  @user = User.create!(email: "test@example.com", password: "password")
  visit new_user_session_path
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "password"
  click_button "Sign in"
end

When("I visit the new event page") do
  visit new_event_path
end

