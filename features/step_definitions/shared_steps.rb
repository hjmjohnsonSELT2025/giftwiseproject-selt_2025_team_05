When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I click {string}") do |button|
  click_on button
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

And('I select {string} with {string}') do |field, value|
  select(value, from: field)
end

When("I click {string} and accept confirmation") do |link_text|
  accept_confirm do
    click_on link_text
  end
end