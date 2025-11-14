require 'cucumber/rails'

# Ensure the test environment is loaded
ENV['RAILS_ENV'] ||= 'test'

# Use transactional fixtures for DB cleaning
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner-active_record to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation