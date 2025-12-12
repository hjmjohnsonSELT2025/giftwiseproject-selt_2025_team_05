When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I click {string}") do |button|
  if page.has_button?(text)
    click_button button
  else
    click_on button
  end
end

Then("I should see {string}") do |text|
  expect(page).to have_content(/#{Regexp.escape(text)}/i)
end

And('I select {string} with {string}') do |field, value|
  select(value, from: field)
end

When("I click {string} and accept confirmation") do |link_text|
  accept_confirm do
    click_on link_text
  end
end

#ChatGPT generated the debugging step below
Then("show me the page") do
  save_and_open_page
end