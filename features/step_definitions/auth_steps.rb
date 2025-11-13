Given("a user is signed in") do
  @user = User.create!(email: "logouttester@example.com", password: "password")
  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password"
  click_button "Log in"
end


Then("I should be on the sign in page") do
  expect(page).to have_current_path(new_user_session_path, ignore_query: true)
end