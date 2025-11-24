class EventUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :authorize_event_owner!

  def create
    @user = User.find(params[:user_id])

    @event_user = @event.event_users.find_or_initialize_by(user: @user)

    @event_user.status = :invited

    if @event_user.save
      redirect_to @event, notice: "#{@user.first_name} has been invited!"
    else
      redirect_to @event, alert: "Could not invite user."
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def authorize_event_owner!
    unless @event.user == current_user
      redirect_to @event, alert: "You are not authorized to invite people to this event."
    end
  end
end
