require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { User.create!(email: "owner@example.com", password: "password", first_name: "Owner", last_name: "User") }
  let(:other_user) { User.create!(email: "other@example.com", password: "password", first_name: "Other", last_name: "User") }

  # Ensure event_type matches your valid Enum/String values
  let(:event) { user.events.create!(name: "Conference", date: Date.tomorrow, address: "City Hall", description: "Annual event", event_type: "friend") }

  before { sign_in user }

  describe "GET #show" do
    let!(:potential_guest) { User.create!(email: "guest@example.com", password: "password", first_name: "John", last_name: "Doe") }

    context "when owner searches for a user" do
      it "assigns @found_users with matching results" do
        get :show, params: { id: event.id, query: "John" }
        expect(assigns(:found_users)).to include(potential_guest)
      end

      it "does not return users who are already joined" do
        EventUser.create!(event: event, user: potential_guest, status: :joined)
        get :show, params: { id: event.id, query: "John" }
        expect(assigns(:found_users)).to be_empty
      end
    end

    context "when non-owner tries to search" do
      before { sign_in other_user }

      it "does not assign @found_users even with query" do
        get :show, params: { id: event.id, query: "John" }
        expect(assigns(:found_users)).to be_nil
      end
    end

    context "when event is deleted" do
      before do
        # FIXED: Use update_columns to ensure the DB is updated ignoring validations/callbacks
        event.update_columns(deleted: true)
      end

      it "redirects to root path with alert" do
        get :show, params: { id: event.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include("deleted")
      end
    end
  end

  describe "POST #create" do
    it "creates a new event" do
      expect {
        post :create, params: { event: { name: "New Event", date: Date.tomorrow, address: "City Hall", description: "Desc", event_type: "friend" } }
      }.to change(Event, :count).by(1)
    end

    it "creates an initial event_user record with joined status" do
      post :create, params: { event: { name: "New Event", date: Date.tomorrow, address: "City Hall", description: "Desc", event_type: "friend" } }
      expect(EventUser.last.status).to eq("joined")
      expect(EventUser.last.user).to eq(user)
    end

    it "redirects to the event show page" do
      post :create, params: { event: { name: "Conference", date: Date.tomorrow, address: "Home", event_type: "friend" } }
      expect(response).to redirect_to(assigns(:event))
    end
  end

  describe "GET #edit" do
    it "returns a successful response for owner" do
      get :edit, params: { id: event.id }
      expect(response).to be_successful
    end

    it "redirects non-owners" do
      sign_in other_user
      get :edit, params: { id: event.id }
      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to include("not authorized")
    end
  end

  describe "PATCH #update" do
    it "updates the event attributes" do
      patch :update, params: { id: event.id, event: { name: "Updated Name" } }
      event.reload
      expect(event.name).to eq("Updated Name")
    end

    it "redirects to the show page after update" do
      patch :update, params: { id: event.id, event: { name: "Updated Name" } }
      expect(response).to redirect_to(event)
    end
  end

  describe "DELETE #destroy" do
    it "marks the event as deleted" do
      delete :destroy, params: { id: event.id }
      event.reload
      expect(event.deleted).to be true
    end

    it "updates all event_users statuses to left" do
      EventUser.create!(event: event, user: other_user, status: :joined)

      delete :destroy, params: { id: event.id }
      expect(EventUser.where(event: event).pluck(:status)).to all(eq("left"))
    end

    it "redirects to root with a notice" do
      delete :destroy, params: { id: event.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Event deleted successfully.")
    end

    it "prevents non-owners from deleting the event" do
      sign_in other_user
      delete :destroy, params: { id: event.id }
      event.reload
      expect(event.deleted).to be_falsey
      expect(response).to redirect_to(events_path)
    end
  end
end