Given("I have an event with another participant") do
  @event = @user.events.create!(
    name: "Holiday Party",
    address: "Old Capital Mall",
    description: "Celebrating end of finals!",
    event_type: :family
  )

  @host_event_user = @event.event_users.create!(user: @user, status: :joined)

  @friend = User.create!(
    email: "steve.friend@example.com",
    password: "password",
    first_name: "Steve",
    last_name: "Friend"
  )
  @friend_event_user = @event.event_users.create!(user: @friend, status: :joined)
end

When("I visit the event page") do
  visit event_path(@event)
end

Then("I should see a gift ideas button for the other participant") do
  expect(page).to have_link("Get gift ideas", href: event_event_user_gift_suggestions_path(@event, @friend_event_user))
end

Then("I should not see a gift ideas button for myself") do
  expect(page).not_to have_link("Get gift ideas", href: event_event_user_gift_suggestions_path(@event, @host_event_user))
end

When("I click the gift ideas button for the other participant") do
  click_link "Get gift ideas", href: event_event_user_gift_suggestions_path(@event, @friend_event_user)
end

Then("I should be on the gift suggestions page for that participant") do
  expect(page).to have_current_path(event_event_user_gift_suggestions_path(@event, @friend_event_user), ignore_query: true)
end