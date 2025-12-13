# features/support/env.rb
require 'cucumber/rails'
require 'selenium-webdriver'
require 'warden'
include Warden::Test::Helpers

#ChatGPT generated Capybara driver config and Warden config
Warden.test_mode!  # enables programmatic login

After do
  Warden.test_reset!  # resets session after each scenario
end

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.javascript_driver = :selenium_chrome_headless

# Ensure the test environment is loaded
ENV['RAILS_ENV'] ||= 'test'

# Use transactional fixtures for DB cleaning
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner-active_record to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation
