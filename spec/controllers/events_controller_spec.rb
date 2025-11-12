require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { User.create!(email: "user@example.com", password: "password") }

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
end
