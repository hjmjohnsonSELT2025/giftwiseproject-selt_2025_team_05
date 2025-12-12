Given('I am logged in as a user named {string} with email {string}') do |first_name, email|
  @user = User.find_or_create_by!(email: email) do |u|
    u.password = "password"
    u.first_name = first_name
  end

  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password"
  click_button "Sign in"
end

Then('the form should have an invalid input message') do
  expect(page).to have_selector('input:invalid')
end
