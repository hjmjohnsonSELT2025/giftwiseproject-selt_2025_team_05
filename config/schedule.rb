# config/schedule.rb
# Run daily at 9:00 AM
# every :day, at: '9:00 am' do
#   runner "SendEventRemindersJob.perform_later"
# end

# for testing(production):
 every 2.minute do
  runner "SendEventRemindersJob.perform_later"
end

# for testing(development):
# env :PATH, ENV['PATH']
# set :environment, "development"
# set :output, { error: '/tmp/whenever_error.log', standard: '/tmp/whenever.log' }
# every 1.minute do
#   runner "SendEventRemindersJob.perform_now"
# end