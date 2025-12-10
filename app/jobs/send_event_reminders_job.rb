# app/jobs/send_event_reminders_job.rb
class SendEventRemindersJob < ApplicationJob
  def perform
    target_date = 3.days.from_now.to_date
    Rails.logger.info "=" * 50
    Rails.logger.info "[EventReminder] Starting job at #{Time.current}"
    Rails.logger.info "[EventReminder] Looking for events on: #{target_date}"

    events = Event.where("DATE(date) = ?", target_date)
                  .where(deleted: false)

    Rails.logger.info "[EventReminder] Found #{events.count} event(s) to send reminders for"

    if events.empty?
      Rails.logger.info "[EventReminder] No events found. Exiting."
      Rails.logger.info "=" * 50
      return
    end

    total_emails_sent = 0

    events.each do |event|
      Rails.logger.info "-" * 40
      Rails.logger.info "[EventReminder] Processing event: '#{event.name}' (ID: #{event.id})"
      Rails.logger.info "[EventReminder]   Event date: #{event.date}"
      Rails.logger.info "[EventReminder]   Event type: #{event.event_type}"

      creator = User.find(event.user_id)
      participants = User.joins(:event_users).where(event_users: { event_id: event.id,
                                                                   status: :joined })
      all_people = [creator] + participants.to_a
      unique_people = all_people.uniq

      Rails.logger.info "[EventReminder]   Creator: #{creator.email}"
      Rails.logger.info "[EventReminder]   Total participants: #{participants.count}"
      Rails.logger.info "[EventReminder]   Unique recipients: #{unique_people.count}"

      unique_people.each do |person|
        Rails.logger.info "[EventReminder]   Sending email to: #{person.email} (User ID: #{person.id})"
        begin
          ApplicationMailer.event_reminder(event, person).deliver_now
          Rails.logger.info "[EventReminder]   ✓ Email sent successfully to #{person.email}"
          total_emails_sent += 1
        rescue => e
          Rails.logger.error "[EventReminder]   ✗ Failed to send email to #{person.email}: #{e.message}"
        end
      end
    end

    Rails.logger.info "-" * 40
    Rails.logger.info "[EventReminder] Job completed. Total emails sent: #{total_emails_sent}"
    Rails.logger.info "=" * 50
  end
end

# Last deployed: 2025-12-06 20:21:50
