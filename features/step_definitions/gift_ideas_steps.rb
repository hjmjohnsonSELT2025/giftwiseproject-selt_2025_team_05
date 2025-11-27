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
    last_name: "Friend",
  )

  @friend.update!(
    bio: "Basketball player and videogames. I love anything Hawkeyes",
    birthdate: Date.new(2015, 5, 1)
  )

  @friend.preferences.create!(
    item_name: "Hawkeye basketball tickets",
    cost: 30,
    notes: "Oregon, UCLA, or USC game at home"
  )
  @friend_event_user = @event.event_users.create!(user: @friend, status: :joined)
end

Given("the gift assistant is stubbed to reply {string}") do |reply|
  allow_any_instance_of(GiftAssistant::ChatService).to receive(:respond).and_return(reply)
end

When("I visit the event page") do
  visit event_path(@event)
end

When("I click the gift ideas button for the other participant") do
  click_link "Get gift ideas", href: event_event_user_gift_suggestions_path(@event, @friend_event_user)
end

When("I open the gift ideas page for the other participant") do
  visit event_event_user_gift_suggestions_path(@event, @friend_event_user)
end

Then("I should see a gift ideas button for the other participant") do
  expect(page).to have_link("Get gift ideas", href: event_event_user_gift_suggestions_path(@event, @friend_event_user))
end

Then("I should not see a gift ideas button for myself") do
  expect(page).not_to have_link("Get gift ideas", href: event_event_user_gift_suggestions_path(@event, @host_event_user))
end

Then("I should be on the gift suggestions page for that participant") do
  expect(page).to have_current_path(event_event_user_gift_suggestions_path(@event, @friend_event_user), ignore_query: true)
end

Then("I should see the participant's bio and wishlist") do
  expect(page).to have_content(@friend.bio)
  expect(page).to have_content("Wishlist:")
  expect(page).to have_content("#{@friend.preferences.count} items")
end

Then("I should see the assistant prompt form") do
  expect(page).to have_selector("form textarea[name='prompt']")
  expect(page).to have_button("Ask the assistant")
end

