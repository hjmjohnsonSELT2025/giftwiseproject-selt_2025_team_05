class GiftHistoryService
  def initialize(user, friend)
    @user = user
    @friend = friend
  end

  def fetch
    shared_events = shared_events_between_users

    upcoming = []
    past = []

    shared_events.each do |event|
      prefs = relevant_preferences_for_event(event)

      if upcoming_event?(event)
        # include claimed OR purchased
        upcoming += prefs
      else
        # for past events, only show purchased items
        past += prefs.select(&:purchased)
      end
    end

    upcoming.sort_by! { |p| p.event.date }
    past.sort_by!    { |p| p.event.date }.reverse!

    [upcoming, past]
  end

  def has_history?
    upcoming, past = fetch
    upcoming.any? || past.any?
  end

  private

  def shared_events_between_users
    Event.joins(:event_users)
         .where(event_users: { user_id: @user.id })
         .joins("INNER JOIN event_users eu2 ON eu2.event_id = events.id")
         .where("eu2.user_id = ?", @friend.id)
         .distinct
  end

  def relevant_preferences_for_event(event)
    Preference.includes(:event)
              .where(
                event_id: event.id,
                user_id:  @friend.id,
                giver_id: @user.id
              )
  end

  def upcoming_event?(event)
    event.date.in_time_zone.to_date >= Time.zone.today
  end
end
