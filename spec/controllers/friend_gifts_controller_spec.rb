require "rails_helper"

RSpec.describe FriendGiftsController, type: :controller do

  let(:user) {User.create!(email: "user@example.com", password: "password", first_name: "Main", last_name: "User")}
  let(:friend) {User.create!(email: "friend@example.com", password: "password", first_name: "Friend", last_name: "User")}
  let(:event) {user.events.create!(name: "Birthday Party", date: Date.tomorrow, address: "123 Main St", description: "Party", event_type: "friend")}

  before do
    sign_in user
    EventUser.create!(event: event, user: friend, status: :joined)
  end

  describe "GET #index" do
    it "assigns the friend" do
      get :index, params: { id: friend.id }
      expect(assigns(:friend)).to eq(friend)
    end

    it "assigns upcoming and past gifts" do
      get :index, params: { id: friend.id }

      expect(assigns(:upcoming_gifts)).to be_an(Array)
      expect(assigns(:past_gifts)).to be_an(Array)
    end

    it "returns a successful response" do
      get :index, params: { id: friend.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
