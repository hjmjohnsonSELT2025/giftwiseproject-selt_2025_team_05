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
  email = "#{name.downcase}@gmail.com"
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

Given("{string} has an event named {string} at address {string}") do |user_name, event_name, address|
  user = User.find_by!(first_name: user_name)
  user.events.create!(
    name: event_name,
    date: Date.tomorrow,
    address: address,
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
  EventUser.find_or_create_by!(user: user, event: event, status: :joined)
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


# 1. Affirmative Step: Check that someone IS in the participants list
Then("I should see {string} in the participants list") do |name|
  # Find the specific Card that contains the header "Participants"
  participant_card = find('.card', text: 'Participants')

  within(participant_card) do
    expect(page).to have_content(name)
  end
end

# 2. Negative Step: Check that someone is NOT in the participants list
# This will now PASS even if Bob is visible in the "Invite Friends" list below
Then("I should not see {string} in the participants list") do |name|
  participant_card = find('.card', text: 'Participants')

  within(participant_card) do
    expect(page).not_to have_content(name)
  end
end

Given("the following events exist:") do |table|
  # Table headers: name, date_offset (days), status, event_type (optional)
  table.hashes.each do |row|
    date = row['date_offset'].to_i.days.from_now
    event_type = row['event_type'] || "family"

    # We use save(validate: false) if date is in the past to bypass the creation validation
    event = Event.new(
      name: row['name'],
      date: date,
      address: "123 Cucumber St",
      event_type: event_type,
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

Given("I have a friend named {string}") do |full_name|
  first, last = full_name.split(" ")
  friend = User.create!(
    email: "#{first.downcase}@example.com",
    password: "password",
    first_name: first,
    last_name: last
  )

  # Create the friendship in the database (Adjust based on your Friendship model)
  # Assuming you have a standard Friendship model
  Friendship.create!(user: @user, friend: friend, status: :accepted)
  Friendship.create!(user: friend, friend: @user, status: :accepted)
end

Then("I should see {string} next to {string}") do |status, name|
  # Finds the row containing the name, checks for status badge
  row = find('tr', text: name)
  expect(row).to have_content(status)
end

Then("I should see {string} within the invite suggestions") do |name|
  # This targets the "Invite Friends" card/table
  within(".card", text: "Invite Friends") do
    expect(page).to have_content(name)
  end
end

Then("I should not see {string} within the invite suggestions") do |name|
  within(".card", text: "Invite Friends") do
    expect(page).not_to have_content(name)
  end
end

When("I click {string} for user {string}") do |button_text, user_name|
  # 1. Scope strictly to the "Invite Friends" card so we don't accidentally
  #    find the user in the "Participants" list (if they are already there).
  within(".card", text: "Invite Friends") do

    # 2. Find the row containing the user's name.
    #    Add `match: :first` to ignore duplicates if the user appears twice in the list.
    row = find('tr', text: user_name, match: :first)

    # 3. Click the specific button inside that row
    within(row) do
      click_button button_text
    end
  end
end

When("I check {string}") do |label_text|
  # Scope to the specific list and grab the first match to ignore any ambiguity
  within(".friend-list-container") do
    check(label_text, allow_label_click: true, match: :first)
  end
end

# Step to fill in date fields with dynamic dates
When("I fill in {string} with a date {int} days from now") do |field, days|
  date_value = days.days.from_now.to_date.to_s
  fill_in field, with: date_value
end

# Clone event steps
Given("{string} has been invited to {string}") do |user_name, event_name|
  first_name = user_name.split(" ").first
  user = User.find_by!(first_name: first_name)
  event = Event.find_by!(name: event_name)
  EventUser.find_or_create_by!(user: user, event: event) do |eu|
    eu.status = :invited
  end
end

Given("I have a past event named {string}") do |event_name|
  past_date = 1.month.ago
  event = Event.new(
    name: event_name,
    date: past_date,
    address: "123 Past St",
    description: "A past event",
    event_type: "friend",
    user: @user
  )
  event.save(validate: false) # bypass date validation
  EventUser.create!(user: @user, event: event, status: :joined)
end

Given("I have an existing family event named {string}") do |event_name|
  @user.events.create!(
    name: event_name,
    date: 1.week.from_now,
    address: "123 Family St",
    description: "Family event description",
    event_type: "family"
  )
end

Then("the {string} field should contain {string}") do |field, value|
  expect(page).to have_field(field, with: value)
end

Then("the {string} field should have {string} selected") do |field, value|
  expect(page).to have_select(field, selected: value)
end

Then("{string} should be checked in the friends list") do |name|
  within(".friend-list-container") do
    # Find the friend-item div containing the name, then find the checkbox within it
    friend_item = find(".friend-item", text: /#{name}/i, match: :first)
    checkbox = friend_item.find("input[type='checkbox']", visible: :all)
    expect(checkbox).to be_checked
  end
end