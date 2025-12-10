class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # Determine the view mode (default to upcoming)
    @view_mode = params[:view] == 'past' ? 'past' : 'upcoming'

    # Base query for joined/invited events that aren't deleted
    # Join the organizer (user) table to enable searching by organizer name
    base_query = current_user.event_users
                             .joins(event: :user)
                             .includes(event: :user)
                             .references(:event)
                             .where("events.deleted = ?", false)

    # Apply status filter (default to both joined and invited)
    if params[:status].present? && %w[joined invited].include?(params[:status])
      base_query = base_query.where(status: params[:status])
    else
      base_query = base_query.where(status: [ :invited, :joined ])
    end

    # Apply event type filter
    if params[:event_type].present? && Event.event_types.key?(params[:event_type])
      base_query = base_query.where(events: { event_type: params[:event_type] })
    end

    # Apply date filter
    if params[:date_from].present?
      base_query = base_query.where("events.date >= ?", Date.parse(params[:date_from]).beginning_of_day)
    end
    if params[:date_to].present?
      base_query = base_query.where("events.date <= ?", Date.parse(params[:date_to]).end_of_day)
    end

    # Apply search filter if query is present
    # Search across: name, address, and organizer name (event_type and date have dedicated filters)
    if params[:query].present?
      search_term = "%#{params[:query].downcase}%"
      base_query = base_query.where(
        "LOWER(events.name) LIKE :q OR LOWER(events.address) LIKE :q OR " \
        "LOWER(users.first_name) LIKE :q OR LOWER(users.last_name) LIKE :q OR " \
        "LOWER(users.first_name || ' ' || users.last_name) LIKE :q",
        q: search_term
      )
    end

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