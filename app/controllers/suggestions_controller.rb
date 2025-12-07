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
      redirect_to user_gift_summary_path(user_id: @suggestion.recipient, event_id: @suggestion.event), notice: "Gift suggestion added!"
    else
      redirect_to new_suggestion_path(user_id: @user.id, event_id: @event.id), notice: "Unable to save gift suggestion."
    end
  end


  #redirects to the user gift summary's show view
  def toggle_purchase_suggestion
    @suggestion = Suggestion.find(params[:id])
    if params[:suggestion][:purchased] == "1"
      @suggestion.purchased = true
    else
      @suggestion.purchased = false
    end
    if @suggestion.save
      redirect_to user_gift_summary_path(user_id: @suggestion.recipient_id, event_id: @suggestion.event), notice: "Purchased status changed successfully!"
    else
      redirect_to user_gift_summary_path(user_id: @suggestion.recipient_id, event_id: @suggestion.event), alert: "Could not change purchase status."
    end

  end

  def toggle_purchase_suggestion_show
    @suggestion = Suggestion.find(params[:id])
    if params[:suggestion][:purchased] == "1"
      @suggestion.purchased = true
    else
      @suggestion.purchased = false
    end
    if @suggestion.save
      redirect_to @suggestion.event, notice: "Purchased status changed successfully!"
    else
      redirect_to @suggestion.event, alert: "Could not change purchase status."
    end

  end

  def show

  end

  def edit
    @suggestion = Suggestion.find(params[:id])
    @redirect = params[:redirect]
  end

  def update
    @suggestion = Suggestion.find(params[:id])
    @recipient = @suggestion.recipient
    @event = Event.find(params[:suggestion][:event_id])
    if @suggestion.update(suggestion_params)
      if params[:suggestion][:redirect] == "user_gift_summary"
        redirect_to user_gift_summary_path(user_id: @recipient.id, event_id: @event.id), notice: "Item updated successfully!"
      else
        redirect_to @event, notice: "Item updated successfully!"
      end
    else
      render :edit
    end
  end

  def destroy
    @suggestion = Suggestion.find(params[:id])
    @recipient = @suggestion.recipient
    @event = @suggestion.event
    @suggestion.destroy
    if params[:redirect] == "user_gift_summary"
      redirect_to user_gift_summary_path(user_id: @recipient.id, event_id: @event.id), notice: "Suggestion removed"
    else
      redirect_to @event, notice: "Suggestion removed"
    end
  end

  private


  def suggestion_params
    params.require(:suggestion).permit(:item_name, :cost, :notes, :event_id, :user_id, :recipient_id)
  end

end