# lib/tasks/scheduler.rake
# Tasks for Heroku Scheduler to run

desc "Send event reminder emails for events happening in 3 days"
task send_event_reminders: :environment do
  puts "Starting event reminder job at #{Time.current}"
  SendEventRemindersJob.perform_now
  puts "Finished event reminder job at #{Time.current}"
end
