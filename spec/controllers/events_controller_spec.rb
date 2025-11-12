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
end
