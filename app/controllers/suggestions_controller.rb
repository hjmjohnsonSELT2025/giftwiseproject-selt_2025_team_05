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
    suggestion_attrs = params[:suggestion] || {}
    @suggestion.item_name = suggestion_attrs[:item_name].presence || params[:item_name]
    @suggestion.cost = suggestion_attrs[:cost].presence || params[:cost]
    @suggestion.notes = suggestion_attrs[:notes].presence || params[:notes]
    @suggestion.recipient = User.find(params[:recipient_id])
    @suggestion.event = Event.find(params[:event_id])
    redirect_path = params[:redirect_to].presence

    if @suggestion.save
      if redirect_path
        redirect_to redirect_path, notice: "Gift suggestion added!"
      else
        redirect_to user_gift_summary_path(user_id: @suggestion.recipient, event_id: @suggestion.event), notice: "Gift suggestion added!"
      end
    else
      if redirect_path
        redirect_to redirect_path, alert: "Unable to save gift suggestion."
      else
        redirect_to new_suggestion_path(user_id: @suggestion.user.id, event_id: @suggestion.event.id), alert: "Unable to save gift suggestion."
      end
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
      if params[:redirect] == "user_gift_summary"
        redirect_to user_gift_summary_path(user_id: @suggestion.recipient_id, event_id: @suggestion.event), notice: "Purchased status changed successfully!"
      else
        redirect_to @suggestion.event, notice: "Purchased status changed successfully!"
      end
    else
      redirect_to user_gift_summary_path(user_id: @suggestion.recipient_id, event_id: @suggestion.event), alert: "Could not change purchase status."
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
    params.require(:suggestion).permit(:item_name, :cost, :notes, :event_id, :user_id)
  end

end
