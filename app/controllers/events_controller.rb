class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_event_owner!, only: [:edit, :update, :destroy]
  def new
    @event = current_user.events.build
  end

  def destroy
    @event.event_users.update_all(status: :left)
    @event.update(deleted: true)
    redirect_to root_path, notice: "Event deleted successfully."
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      EventUser.create!(event: @event, user: current_user, status: :joined)
      redirect_to @event, notice: "Event created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
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

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event_owner!
    unless @event.user == current_user
      redirect_to events_path, alert: "You are not authorized to edit this event."
    end
  end

  def event_params
    params.require(:event).permit(:name, :date, :address, :description)
  end
end
