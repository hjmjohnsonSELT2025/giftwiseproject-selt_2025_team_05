class GiftHistoryService
  def initialize(user, friend)
    @user = user
    @friend = friend
  end

  def fetch
    upcoming = []
    past     = []

    shared_events_between_users.find_each do |event|
      prefs = relevant_preferences_for_event(event)
      suggs = relevant_suggestions_for_event(event)

      if upcoming_event?(event)
        # upcoming: include claimed OR purchased
        upcoming.concat(prefs)
        upcoming.concat(suggs)
      else
        # past: only include purchased
        past.concat(prefs.select(&:purchased))
        past.concat(suggs.select(&:purchased))
      end
    end

    upcoming.sort_by! { |g| g.event.date }
    past.sort_by!     { |g| g.event.date }.reverse!

    [upcoming, past]
  end

  def has_history?
    shared_events_between_users.any? do |event|
      prefs = relevant_preferences_for_event(event)
      suggs = relevant_suggestions_for_event(event)

      if upcoming_event?(event)
        prefs.exists? || suggs.exists?
      else
        prefs.where(purchased: true).exists? ||
          suggs.where(purchased: true).exists?
      end
    end
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

  def relevant_suggestions_for_event(event)
    Suggestion.includes(:event)
              .where(
                event_id:    event.id,
                recipient_id: @friend.id,
                user_id:     @user.id
              )
  end

  def upcoming_event?(event)
    event.date.in_time_zone.to_date >= Time.zone.today
  end
end
