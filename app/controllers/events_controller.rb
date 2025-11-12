class EventsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = current_user.events.build
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

  private

  def event_params
    params.require(:event).permit(:name, :date, :address, :description)
  end
end