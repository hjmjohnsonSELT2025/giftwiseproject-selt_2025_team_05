class GiftSuggestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :set_event_user
  before_action :authorize_viewer!

  def show
    prepare_view_state
  end

  def create
    prepare_view_state

    @user_prompt = params[:prompt].to_s.strip
    if @user_prompt.blank?
      flash.now[:alert] = "Please enter a question before asking the assistant"
      render :show, status: :unprocessable_entity
      return
    end

    @conversation = parsed_conversation + [{ role: "user", content: @user_prompt }]
    assistant_reply = chat_service.respond(
      recipient: @recipient,
      event: @event,
      conversation: @conversation,
      prompt: @user_prompt
    )

    @conversation << { role: "assistant", content: assistant_reply }
    @serialized_conversation = @conversation.to_json

    render :show
  end

  private

  def prepare_view_state
    @recipient  = @event_user.user
    @bio = @recipient.bio
    @wishlist = @recipient.preferences.order(created_at: :desc)
    @saved_gifts = current_user.suggestions.where(event: @event, recipient: @recipient).order(created_at: :desc)
    @conversation = parsed_conversation
    @serialized_conversation = @conversation.to_json
  end

  def parsed_conversation
    JSON.parse(params[:conversation].presence || "[]")
        .map { |msg| { role: msg["role"], content: msg["content"] } }
  rescue JSON::ParserError
    []
  end

  def chat_service
    GiftAssistant::ChatService.new
  end

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
