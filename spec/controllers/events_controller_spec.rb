require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { User.create!(email: "user@example.com", password: "password") }
  let(:event) { user.events.create!(name: "Old Name", address: "City Hall", description: "Annual event") }

  before { sign_in user }

  describe "POST #create" do
    it "creates a new event" do
      expect {
        post :create, params: { event: { name: "Conference", address: "City Hall", description: "Annual event" } }
      }.to change(Event, :count).by(1)
    end

    it "redirects to the event show page" do
      post :create, params: { event: { name: "Conference" } }
      expect(response).to redirect_to(assigns(:event))
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: event.id }
      expect(response).to be_successful
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
      delete :destroy, params: { id: event.id }
      expect(EventUser.where(event: event).pluck(:status)).to all(eq("left"))
    end

    it "redirects to root with a notice" do
      delete :destroy, params: { id: event.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Event deleted successfully.")
    end

    it "prevents non-owners from deleting the event" do
      other_user = User.create!(email: "other@example.com", password: "password")
      sign_in other_user
      delete :destroy, params: { id: event.id }
      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to eq("You are not authorized to edit this event.")
    end
  end
end