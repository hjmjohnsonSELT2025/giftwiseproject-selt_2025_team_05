Given('I check the preference purchase checkbox') do
  check('preference[purchased]')
end

Given('the purchase checkbox should be checked') do
  #ChatGPT generated the line below:
  expect(page).to have_checked_field('preference[purchased]')
end

Given('I uncheck the preference purchase checkbox') do
  uncheck('preference[purchased]')
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
  check('suggestion[purchased]')
end

Given('the suggestion checkbox should be checked') do
  #ChatGPT generated the line below:
  expect(page).to have_checked_field('suggestion[purchased]')
end

Given('I uncheck the suggestion purchase checkbox') do
  uncheck('suggestion[purchased]')
end

Given('the suggestion checkbox should be unchecked') do
  expect(page).to have_unchecked_field('suggestion[purchased]')
end
