namespace :reminders do
  desc "Send event reminders"
  task send: :environment do
    puts "#{Time.now}: Starting to send event reminders..."

    events = Event.where("DATE(date) = ?", 3.days.from_now.to_date)
                  .where(deleted: false)

    puts "Found #{events.count} events to notify"

    events.each do |event|
      creator = User.find(event.user_id)
      participants = User.joins(:event_users).where(event_users: { event_id: event.id })
      all_people = [creator] + participants.to_a

      all_people.uniq.each do |person|
        puts "Sending reminder for event #{event.id} to #{person.email}"
        ApplicationMailer.event_reminder(event, person).deliver_later
      end
    end

    puts "Reminder sending complete!"
  end
end