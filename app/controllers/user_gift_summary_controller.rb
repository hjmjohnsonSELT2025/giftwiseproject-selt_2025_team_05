class UserGiftSummaryController < ApplicationController
  before_action :authenticate_user!
  def show
    @event = Event.find(params[:event_id])
    @giver = current_user
    @recipient = User.find(params[:user_id])
    @wishlist_items = @recipient.preferences
    @wishlist_items_claimed = @wishlist_items.where(giver: @giver, event: @event)
    @wishlist_items_table_view = @recipient.preferences.where.not(giver_id: @giver.id) + @recipient.preferences.where(giver_id: nil)
    @suggestions = @giver.suggestions.where(event: @event, recipient: @recipient)
    @combined_items = @wishlist_items_claimed + @suggestions
    Rails.logger.debug "Wishlist giver_ids: #{@wishlist_items_table_view.pluck(:giver_id).inspect}"
    @event_user = EventUser.where(:event_id => @event.id, :user_id => @recipient.id).first
  end
  def add_gift
    @event = Event.find(params[:event_id])
    @giver = current_user
    @recipient = User.find(params[:user_id])
    @wishlist_items = @recipient.preferences
  end
end
