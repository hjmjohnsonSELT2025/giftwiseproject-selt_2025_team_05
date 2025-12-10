# lib/tasks/scheduler.rake
# Tasks for Heroku Scheduler to run

desc "Send event reminder emails for events happening in 3 days"
task send_event_reminders: :environment do
  puts "[Scheduler] =========================================="
  puts "[Scheduler] Task started at #{Time.current}"
  puts "[Scheduler] Environment: #{Rails.env}"
  puts "[Scheduler] GMAIL_USERNAME configured: #{ENV['GMAIL_USERNAME'].present?}"
  puts "[Scheduler] GMAIL_APP_PASSWORD configured: #{ENV['GMAIL_APP_PASSWORD'].present?}"
  puts "[Scheduler] =========================================="

  SendEventRemindersJob.perform_now

  puts "[Scheduler] Task completed at #{Time.current}"
end
