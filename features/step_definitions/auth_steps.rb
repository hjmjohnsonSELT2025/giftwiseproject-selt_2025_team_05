Given("a registered user exists") do
  @user = User.find_or_create_by!(email: "dummy@example.com") do |u|
    u.password = "123456"
  end
end

Given("I am logged in as a user") do
  @user = User.create!(email: "logouttester@example.com", password: "password")
  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password"
  click_button "Sign in"
end

Given("I am logged in as a user named {string} with email {string}") do |first_name, email|
  @user = User.find_or_create_by!(email: email) do |u|
    u.first_name = first_name
    u.password = "password"
  end

  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password"
  click_button "Sign in"
end

When("I visit the home page") do
  visit root_path
end

When("I visit the sign in page") do
  visit new_user_session_path
end

When("I sign in with email {string} and password {string}") do |email, password|
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Sign in"
end

Then("I should be on the sign in page") do
  expect(page).to have_current_path(new_user_session_path, ignore_query: true)
end

Then("I should be on the home page") do
  expect(page).to have_current_path(root_path, ignore_query: true)
end
