Before do
  @current_user_email = nil
end

Given('an event {string} exists hosted by {string}') do |event_name, host_email|
  host = User.find_or_create_by!(email: host_email) do |u|
    u.password = "password"
  end

  @event = Event.find_or_create_by!(
    name: event_name,
    user: host,
    address: "123 Street",
    event_type: "friend",
    date: Date.today + 5.days
  )

  EventUser.find_or_create_by!(event: @event, user: host) do |eu|
    eu.status = :joined
    eu.budget = 0
  end
end

Given('{string} has a budget of {int} for event {string}') do |email, budget, event_name|
  user = User.find_or_create_by!(email: email) { |u| u.password = "password" }
  event = Event.find_by!(name: event_name)

  event_user = EventUser.find_or_create_by!(event: event, user: user)
  event_user.update!(budget: budget)
end

When('I go to the event page for {string}') do |event_name|
  event = Event.find_by!(name: event_name)
  visit event_path(event)
end

Given('a gift {string} costing {int} exists for {string} in {string}') do |item_name, cost, receiver_email, event_name|
  receiver = User.find_or_create_by!(email: receiver_email) { |u| u.password = "password" }
  event = Event.find_by!(name: event_name)

  Preference.create!(
    item_name: item_name,
    cost: cost,
    user: receiver,
    event: event,
    purchased: false
  )

  EventUser.find_or_create_by!(event: event, user: receiver, status: 1)
end

When("I view the wishlist of {string} for event {string}") do |email, event_name|
  user = User.find_by!(email: email)
  event = Event.find_by!(name: event_name)

  visit view_user_wishlist_preferences_path(
          user_id: user.id,
          event_id: event.id
        )
end

Given("I have claimed {string} in {string}") do |item_name, event_name|
  event = Event.find_by!(name: event_name)
  pref = Preference.find_by!(item_name: item_name, event: event)

  # The current user is always Alice in this feature
  claimer = User.find_by!(email: @current_user_email || "alice@test.com")
  pref.update!(giver: claimer)
end

Then('the {string} button should be disabled') do |text|
  btn = find_button(text, disabled: true, exact: false)
  expect(btn).to be_disabled
end

When("I mark the gift {string} as purchased") do |item_name|
  pref = Preference.find_by!(item_name: item_name)
  pref.update!(purchased: true)
end

Then('I should see Total Claimed of {string}') do |amount|
  visit event_path(@event) unless page.has_css?("div.bg-light")

  within("div.bg-light") do
    expect(page).to have_text(/Total\s+Claimed:\s+#{Regexp.escape(amount)}/i)
  end
end

Then('I should see Remaining budget of {string}') do |amount|
  visit event_path(@event) unless page.has_css?("div.bg-light")

  within("div.bg-light") do
    expect(page).to have_text(/Remaining(\s+budget)?:\s+#{Regexp.escape(amount)}/i)
  end
end

Then('I should see a budget warning') do
  expect(page.html).to match(/Claiming this gift exceeds your budget/i)
end

Then('show me the page') do
  save_and_open_page
end
