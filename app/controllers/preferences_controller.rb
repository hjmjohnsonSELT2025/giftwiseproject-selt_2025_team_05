class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_preference, only: [ :edit, :update, :destroy ]

  def claim_preference
    @item = Preference.find(params[:item_id])
    @item.giver = User.find(params[:user_id])
    @item.event = Event.find(params[:event_id])
    if @item.save
      redirect_to user_gift_summary_path(user_id: @item.user_id,  event_id: @item.event), notice: "Gift claimed successfully!"
    else
      redirect_to user_gift_summary_path(user_id: @item.user_id,  event_id: @item.event), alert: "Could not claim gift."
    end
  end

  def unclaim_preference
    @item = Preference.find(params[:item_id])
    @event = Event.find(params[:event_id])

    @item.giver = nil
    @item.purchased = nil
    @item.event = nil

    if @item.save
      if params[:redirect] == "wishlist"
        redirect_to view_user_wishlist_preferences_path(user_id: @item.user_id, event_id: @event.id), notice: "Gift unclaimed successfully!"
      elsif params[:redirect] == "user_gift_summary"
        redirect_to user_gift_summary_path(user_id: @item.user_id, event_id: @event.id), notice: "Gift unclaimed successfully!"
      else
        redirect_to @event, notice: "Gift unclaimed successfully!"
      end
    else
        redirect_to @event, alert: "Could not unclaim gift."
    end

  end

  def toggle_purchase
    @preference = Preference.find(params[:id])
    if params[:preference][:purchased] == "1"
      @preference.purchased = true
    else
      @preference.purchased = false
    end
    if @preference.save
      if params[:redirect] == "user_gift_summary"
        redirect_to user_gift_summary_path(user_id: @preference.user_id, event_id: @preference.event), notice: "Purchased status changed successfully!"
      else
        redirect_to @preference.event, notice: "Purchased status changed successfully!"
      end
    else
      redirect_to user_gift_summary_path(user_id: @preference.user_id, event_id: @preference.event), alert: "Could not change purchase status."
    end
  end

  def view_user_wishlist
    @user = User.find(params[:user_id])
    @event = Event.find(params[:event_id])
    @preferences = @user.preferences
    @suggestions = current_user.suggestions.where(:event_id => @event.id, :recipient_id => @user.id)
    @event_user = EventUser.where(:event_id => @event.id, :user_id => @user.id).first
  end

  def index
    @preferences = current_user.preferences.order(created_at: :desc)
  end


  def new
    @preference = Preference.new
  end

  def create
    @preference = Preference.new(preference_params)
    @preference.user = current_user

    if @preference.save
      redirect_to preferences_path, notice: "Item added to wish list!"
    else
      render :new
    end
  end

  def edit
    # @preference is set by set_preference before_action
  end

  def update
    if @preference.update(preference_params)
      redirect_to preferences_path, notice: "Item updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @preference.destroy
    redirect_to preferences_path, notice: "Item removed from wish list"
  end

  private

  def set_preference
    @preference = current_user.preferences.find(params[:id])
  end

  def preference_params
    params.require(:preference).permit(:item_name, :cost, :notes)
  end
end
