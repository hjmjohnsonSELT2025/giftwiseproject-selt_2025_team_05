class EventUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :authorize_event_owner!, only: [ :create ]

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

  def update
    @event_user = @event.event_users.find(params[:id])
    new_status = params[:status].to_s
    is_owner = @event.user_id == current_user.id
    is_self = @event_user.user_id == current_user.id

    if is_owner && !is_self
      if new_status == 'left'
        @event_user.update(status: :left)
        redirect_to @event, notice: "#{@event_user.user.first_name} has been removed from the event."
      else
        redirect_to @event, alert: "As the owner, you can only remove participants."
      end

    elsif is_self

      if new_status == 'left' && is_owner
        redirect_to root_path, alert: "You cannot leave your own event. You must delete it instead."
        return
      end

      if ['joined', 'declined', 'left'].include?(new_status)
        @event_user.update(status: new_status)

        message = case new_status
                  when 'joined' then "You have successfully joined the event!"
                  when 'declined' then "You have declined the invitation."
                  when 'left' then "You have left the event."
                  end

        redirect_to root_path, notice: message
      else
        redirect_to root_path, alert: "Invalid status update."
      end

    else
      redirect_to root_path, alert: "You are not authorized to perform this action."
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

  def budget_params
    permitted = params.require(:event_user).permit(:budget)

    permitted[:budget] = nil if permitted[:budget].blank?

    permitted
  end

end
