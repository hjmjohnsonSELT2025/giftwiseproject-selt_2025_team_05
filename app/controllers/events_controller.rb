class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_event_owner!, only: [:edit, :update, :destroy]

  def new
    @event = current_user.events.build
    @friends = current_user.all_friends
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      # 1. Add the Creator (You) as 'Joined'
      EventUser.create!(event: @event, user: current_user, status: :joined)

      # 2. NEW: Add selected Friends as 'Invited'
      if params[:participant_ids]
        params[:participant_ids].each do |user_id|
          # Create EventUser for each friend
          EventUser.create(event: @event, user_id: user_id, status: :invited)
        end
      end

      redirect_to @event, notice: "Event created successfully!"
    else
      # NEW: If validation fails, we must reload @friends so the view doesn't crash
      @friends = current_user.all_friends
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Only run this logic if the current user is the host
    if @event.user_id == current_user.id
      # Get IDs of everyone already associated with the event (joined, invited, etc.)
      participant_ids = @event.event_users.pluck(:user_id)

      if params[:query].present?
        # CASE 1: User is searching for someone specific
        @found_users = User.search_by_name_or_email(params[:query])
                           .where.not(id: participant_ids)
      else
        # CASE 2: Default view - Show all friends who aren't in the event yet
        # We use .reject to filter the array of friends
        @found_users = current_user.all_friends.reject { |friend| participant_ids.include?(friend.id) }
      end
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Soft delete logic preserved
    @event.event_users.update_all(status: :left)
    @event.update(deleted: true)
    redirect_to root_path, notice: "Event deleted successfully."
  end

  private

  def set_event
    @event = Event.find_by(id: params[:id])
    if @event.nil? || @event.deleted
      redirect_to root_path, alert: "Event not found or has been deleted."
    end
  end

  def authorize_event_owner!
    unless @event.user == current_user
      redirect_to events_path, alert: "You are not authorized to edit this event."
    end
  end

  def event_params
    params.require(:event).permit(:name, :date, :address, :event_type, :description)
  end
end