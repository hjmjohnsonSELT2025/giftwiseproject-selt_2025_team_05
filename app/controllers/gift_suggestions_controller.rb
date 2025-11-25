class GiftSuggestionsController < ApplicationController 
  before_action :authenticate_user!
  before_action :set_event
  before_action :set_event_user
  before_action :authorize_viewer!

  def show
    @recipient = @event_user.user
    @bio = @recipient.bio
    @wishlist = @recipient.preferences.order(created_at: :desc)
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_event_user
    @event_user = @event.event_users.find(params[:event_user_id])
  end

  def authorize_viewer!
    unless @event.event_users.exists?(user: current_user, status: :joined)
      redirect_to @event, alert: "You can only view gift ideas for events you have joined."
    end
  end
end
