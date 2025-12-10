# This file only for development environment:
env :PATH, ENV['PATH']
set :environment, "development"
# every 1.minute do
#   runner "SendEventRemindersJob.perform_now"
# end
#
# Run daily
every :day, at: '5:49 pm' do
  runner "SendEventRemindersJob.perform_now"
end