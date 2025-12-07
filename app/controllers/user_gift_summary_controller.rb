class UserGiftSummaryController < ApplicationController
  before_action :authenticate_user!
  def show
    @event = Event.find(params[:event_id])
    @giver = current_user
    @recipient = User.find(params[:user_id])
    @wishlist_items = @recipient.preferences
    @wishlist_items_claimed = @wishlist_items.where(giver: @giver, event: @event)
    @suggestions = @giver.suggestions.where(event: @event, recipient: @recipient)
    @combined_items = @wishlist_items_claimed + @suggestions
  end
  def add_gift
    @event = Event.find(params[:event_id])
    @giver = current_user
    @recipient = User.find(params[:user_id])
    @wishlist_items = @recipient.preferences
  end
end
