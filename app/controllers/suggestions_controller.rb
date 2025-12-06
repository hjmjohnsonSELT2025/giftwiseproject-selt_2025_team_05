class SuggestionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @suggestion = Suggestion.new
    @user = User.find(params[:user_id])
    @event = Event.find(params[:event_id])
  end

  def create
    @suggestion = Suggestion.new
    @suggestion.user = User.find(params[:user_id])
    @suggestion.item_name = params[:suggestion][:item_name]
    @suggestion.cost = params[:suggestion][:cost]
    @suggestion.notes = params[:suggestion][:notes]
    @suggestion.recipient = User.find(params[:recipient_id])
    @suggestion.event = Event.find(params[:event_id])

    if @suggestion.save
      redirect_to view_user_wishlist_preferences_path(user_id: @suggestion.recipient, event_id: @suggestion.event), notice: "Gift suggestion added!"
    else
      redirect_to new_suggestion_path(user_id: @user.id, event_id: @event.id), notice: "Unable to save gift suggestion."
    end
  end

  def show

  end

  def edit
  end

  def update

  end

  def destroy
  end
end