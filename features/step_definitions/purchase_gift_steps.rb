Given('I am logged in as a user using Warden named {string} with email {string}') do |first_name, email|
  @user = User.find_or_create_by!(email: email) do |u|
    u.password = "password"
    u.first_name = first_name
  end

  login_as(@user, scope: :user) #ChatGPT generated this line to use with Warden for session management with JS
end

Given('I check the preference purchase checkbox') do
  page.execute_script("document.getElementById('preference_purchased').click()")
end

Given('I uncheck the preference purchase checkbox') do
  #ChatGPT generated the line below
  page.execute_script("document.getElementById('preference_purchased').checked = false; document.getElementById('preference_purchased').form.submit();")
end

Given('{string} has claimed a wishlist gift called {string} for {string} in event {string}') do |user1_first_name, item_name, user2_first_name, event|
  user1 = User.find_by(first_name: user1_first_name)
  user2 = User.find_by(first_name: user2_first_name)
  event = Event.find_by(name: event)

  user2.preferences.create!(
    item_name: item_name,
    cost: 50,
    notes: "My note for the wishlist item.",
    giver: user1,
    event: event
  )
end

Given('{string} has claimed a custom gift called {string} for {string} in event {string}') do |user1_first_name, item_name, user2_first_name, event|
  user1 = User.find_by(first_name: user1_first_name)
  user2 = User.find_by(first_name: user2_first_name)
  event = Event.find_by(name: event)

  user1.suggestions.create!(
    item_name: item_name,
    cost: 50,
    notes: "My note for the wishlist item.",
    recipient: user2,
    event: event
  )
end

Given('I visit the gift summary page for {string} in event {string}') do |first_name, event_name|
  user = User.find_by(first_name: first_name)
  event = Event.find_by(name: event_name)
  visit user_gift_summary_path(user, event)
end

Given('the purchase checkbox should be unchecked') do
  expect(page).to have_unchecked_field('preference[purchased]')
end

Given('I check the suggestion purchase checkbox') do
  page.execute_script("document.getElementById('suggestion_purchased').click()")
end

Given('I uncheck the suggestion purchase checkbox') do
  #ChatGPT generated the line below
  page.execute_script("document.getElementById('suggestion_purchased').checked = false; document.getElementById('suggestion_purchased').form.submit();")

end

Given('the suggestion checkbox should be unchecked') do
  expect(page).to have_unchecked_field('suggestion[purchased]')
end

Given('the purchase status of {string} should be {string}') do |item_name, status|
  expect(page).to have_content('Purchased')
  item = Preference.find_by(item_name: item_name)
  if item.nil?
    item = Suggestion.find_by(item_name: item_name)
  end

  puts item.inspect
  puts status.inspect

  if status == "true"
    expect(item.purchased).to be_truthy
  elsif status == "false"
    expect(item.purchased).to be_falsy
  else
    false
  end
end



