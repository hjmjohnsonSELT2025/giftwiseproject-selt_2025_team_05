class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # Determine the view mode (default to upcoming)
    @view_mode = params[:view] == 'past' ? 'past' : 'upcoming'

    # Base query for joined/invited events that aren't deleted
    base_query = current_user.event_users
                             .includes(:event) # optimize loading
                             .references(:event) # required for the where clause on events table
                             .where(status: [ :invited, :joined ])
                             .where("events.deleted = ?", false)

    # Apply filter based on view mode
    if @view_mode == 'past'
      @event_users = base_query.where("events.date < ?", Date.today)
                               .order("events.date DESC") # Past events usually ordered newest first
    else
      @event_users = base_query.where("events.date >= ?", Date.today)
                               .order("events.date ASC")  # Upcoming events ordered soonest first
    end
  end
end