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

