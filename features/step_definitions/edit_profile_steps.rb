Given("I am a logged in user") do
  @user = User.create!(email: "j@email.com", password: "password", first_name: "Jane", last_name: "Doe", birthdate: "1970-01-01")
  visit new_user_session_path
  fill_in "Email", with: "j@email.com"
  fill_in "Password", with: "password"
  click_button "Log in"
end

When("I click Edit Profile") do |button|
  click_button "Edit Profile"
end