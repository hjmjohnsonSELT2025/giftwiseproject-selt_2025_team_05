When("I visit the new event page") do
  visit new_event_path
end

Given("there is another user named {string}") do |name|
  email = "#{name.downcase}@example.com"
  User.find_or_create_by!(email: email) do |user|
    user.first_name = name
    user.last_name = "Doe"
    user.password = "password"
  end
end

Given("there is another user named {string} with email {string}") do |name, email|
  User.find_or_create_by!(email: email) do |user|
    user.first_name = name
    user.last_name = "Doe"
    user.password = "password"
  end
end

Given("I am logged in as a user named {string}") do |name|
  email = "#{name.downcase}@test.com"
  @user = User.find_or_create_by!(email: email) do |u|
    u.first_name = name
    u.last_name = "User"
    u.password = "password"
  end

  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password"
  click_button "Sign in"
end

Given("I have an existing event named {string}") do |event_name|
  @user.events.create!(
    name: event_name,
    date: Date.tomorrow,
    address: "123 Main St",
    description: "My Description",
    event_type: "friend"
  )
end

Given("{string} has an event named {string}") do |user_name, event_name|
  user = User.find_by!(first_name: user_name)
  user.events.create!(
    name: event_name,
    date: Date.tomorrow,
    address: "456 Other St",
    description: "Description",
    event_type: "friend"
  )
end

Given("{string} has created an event named {string}") do |user_name, event_name|
  step %{"#{user_name}" has an event named "#{event_name}"}
end

Given("{string} is a participant in {string}") do |user_name, event_name|
  user = User.find_by!(first_name: user_name)
  event = Event.find_by!(name: event_name)
  EventUser.create!(user: user, event: event, status: :joined)
end

Given("I have been invited to {string}") do |event_name|
  event = Event.find_by!(name: event_name)
  EventUser.create!(user: @user, event: event, status: :invited)
end

Given("I have joined {string}") do |event_name|
  event = Event.find_by!(name: event_name)
  EventUser.create!(user: @user, event: event, status: :joined)
end

When("I visit the event page for {string}") do |event_name|
  event = Event.find_by!(name: event_name)
  visit event_path(event)
end

Then("I should not see {string}") do |content|
  expect(page).not_to have_content(content)
end

Then("I should not see field {string}") do |field_name|
  expect(page).not_to have_field(field_name)
end

Then("I should see {string} in the search results") do |text|
  expect(page).to have_content(text)
end

Then("I should see {string} within the {string} row") do |text, row_identifier|
  row = find('tr', text: row_identifier)
  expect(row).to have_content(text)
end

Then("I should not see {string} within the upcoming events table") do |text|
  expect(page).not_to have_content(text)
end

Then("I should not see {string} in the list of events") do |text|
  expect(page).not_to have_content(text)
end

Then("I should see {string} in the participants list with status {string}") do |participant_name, status|
  row = find('tr', text: participant_name)
  expect(row).to have_content(status)
end

Then("I should not see {string} in the participants list") do |participant_name|
  if page.has_css?('table')
    expect(page).not_to have_css('table', text: participant_name)
  end
end

Given("the following events exist:") do |table|
  # Table headers: name, date_offset (days), status
  table.hashes.each do |row|
    date = row['date_offset'].to_i.days.from_now

    # We use save(validate: false) if date is in the past to bypass the creation validation
    event = Event.new(
      name: row['name'],
      date: date,
      address: "123 Cucumber St",
      event_type: "family",
      description: "Auto generated",
      user: @user
    )
    event.save(validate: false)

    EventUser.create!(user: @user, event: event, status: row['status'])
  end
end

When("I click the {string} link") do |link_text|
  click_link link_text
end

Then("{string} should have a dimmed style") do |event_name|
  # Finds the row containing the event name, checks for the class 'text-muted'
  row = find('tr', text: event_name)
  expect(row[:class]).to include('text-muted')
end

Then("I should see {string} badge") do |text|
  expect(page).to have_css('.badge', text: text)
end

Then("I should not see button {string}") do |button_text|
  expect(page).not_to have_button(button_text)
end

When("I click {string} for {string}") do |link_text, row_text|
  # 1. Find the table row (tr) that contains the event name (row_text)
  row = find('tr', text: row_text)

  # 2. Scope the click action to ONLY happen inside that specific row
  within(row) do
    click_link(link_text)
  end
end