require "rails_helper"

RSpec.describe GiftSuggestionsController, type: :controller do
  let(:host)    { User.create!(email: "host@example.com", password: "password") }
  let(:friend)  { User.create!(email: "friend@example.com", password: "password") }
  let(:event)   { host.events.create!(name: "Friendsgiving") }
  let!(:host_event_user)   { event.event_users.create!(user: host,   status: :joined) }
  let!(:friend_event_user) { event.event_users.create!(user: friend, status: :joined) }

  before { sign_in(host) }

  describe "POST #create" do
    context "when prompt is blank" do
      it "re renders the page with an alert" do
        post :create, params: {
          event_id: event.id,
          event_user_id: friend_event_user.id,
          prompt: "",
          conversation: "[]"
        }

        expect(response).to be_unprocessable
        expect(flash.now[:alert]).to eq("Please enter a question before asking the assistant")
      end
    end

    context "when prompt is present" do
      it "invokes the chat service and renders the transcript" do
        service = instance_double(GiftAssistant::ChatService, respond: "Mock reply")
        allow(GiftAssistant::ChatService).to receive(:new).and_return(service)

        post :create, params: {
          event_id: event.id,
          event_user_id: friend_event_user.id,
          prompt: "Need ideas",
          conversation: "[]"
        }

        expect(GiftAssistant::ChatService).to have_received(:new)
        expect(service).to have_received(:respond)
        expect(assigns(:conversation).last).to eq(role: "assistant", content: "Mock reply")
        expect(response).to render_template(:show)
      end
    end
  end
end
