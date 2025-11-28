Given('a user {string} exists') do |email|
  User.find_or_create_by!(email: email) do |u|
    u.password = "password"
  end
end

Given('I am logged in as {string}') do |email|
  visit new_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: "password"
  click_button "Sign in"
end

When('I go to the find friends page') do
  visit new_friendship_path
end

When('I press {string}') do |string|
  click_button string
end

#When('I fill in {string} with {string}') do |field, string|
#fill_in field, with: string
#end

#Then('I should not see {string}') do |string|
#expect(page).not_to have_content(string)
#end

Given('{string} has sent a friend request to {string}') do |send, rec|
  sender = User.find_by!(email: send)
  receiver = User.find_by!(email: rec)
  Friendship.create!(user: sender, friend: receiver, status: :pending)
end

When('I go to the friends page') do
  visit friendships_path
end

Then('I should see {string} on the friends page') do |string|
  expect(page).to have_content(string)
end

Given('I am friends with {string}') do |string|
  user   = User.find_by!(email: @current_user_email || User.first.email)
  friend = User.find_by!(email: string)

  Friendship.create!(
    user: user,
    friend: friend,
    status: :accepted
  )
end

Given('I have sent a friend request to {string}') do |string|
  user = User.find_by!(email: @current_user_email || User.first.email)
  friend = User.find_by!(email: string)
  Friendship.create!(user: user, friend: friend, status: :pending)
end

Then('I should see {string} within the row for {string}') do |text, email|
  row = find(:xpath, "//tr[td[contains(., '#{email}')] and .//*[contains(., '#{text}')]]")
  expect(row).to have_content(text)
end