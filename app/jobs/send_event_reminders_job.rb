# app/jobs/send_event_reminders_job.rb
class SendEventRemindersJob < ApplicationJob
  def perform
    events = Event.where("DATE(date) = ?", 3.days.from_now.to_date)
                  .where(deleted: false)

    events.each do |event|
      creator = User.find(event.user_id)
      participants = User.joins(:event_users).where(event_users: { event_id: event.id })
      all_people = [creator] + participants.to_a

      all_people.uniq.each do |person|
        ApplicationMailer.event_reminder(event, person).deliver_later
        #ApplicationMailer.event_reminder(event, person).deliver_now
      end
    end
  end
end

# Last deployed: 2025-12-06 20:21:50
