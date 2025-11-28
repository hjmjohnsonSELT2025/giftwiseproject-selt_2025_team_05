require 'rails_helper'

RSpec.describe "Friendships", type: :request do
  let(:user)   { User.create!(email: "a@test.com", password: "password") }
  let(:friend) { User.create!(email: "b@test.com", password: "password") }

  before do
    sign_in user
  end

  describe "POST /friendships" do
    it "creates a pending friend request" do
      expect {
        post friendships_path, params: { friend_id: friend.id }
      }.to change(Friendship, :count).by(1)

      f = Friendship.last
      expect(f.user).to eq(user)
      expect(f.friend).to eq(friend)

      # String enum + prefix
      expect(f.status).to eq("pending")
      expect(f.status_pending?).to be(true)

      expect(response).to redirect_to(friendships_path)
    end

    it "shows an alert when the friend request cannot be created" do
      expect {
        post friendships_path, params: { friend_id: user.id } # invalid
      }.not_to change(Friendship, :count)

      expect(flash[:alert]).to eq("Unable to send friend request.")
    end
  end

  describe "PATCH /friendships/:id" do
    let!(:request_from_friend) { Friendship.create!(user: friend, friend: user) }

    it "accepts a friend request" do
      patch friendship_path(request_from_friend), params: { status: "accepted" }

      expect(request_from_friend.reload.status).to eq("accepted")
      expect(request_from_friend.reload.status_accepted?).to be(true)

      expect(response).to redirect_to(friendships_path)
    end

    it "declines a friend request" do
      patch friendship_path(request_from_friend), params: { status: "declined" }

      expect(request_from_friend.reload.status).to eq("declined")
      expect(request_from_friend.reload.status_declined?).to be(true)

      expect(response).to redirect_to(friendships_path)
    end
  end

  describe "DELETE /friendships/:id" do
    let!(:friendship) { Friendship.create!(user: user, friend: friend) }

    it "destroys the friendship" do
      expect {
        delete friendship_path(friendship)
      }.to change(Friendship, :count).by(-1)

      expect(response).to redirect_to(friendships_path)
    end

    it "shows an alert when the user is not authorized to delete the friendship" do
      stranger1 = User.create!(email: "stranger1@test.com", password: "password")
      stranger2 = User.create!(email: "stranger2@test.com", password: "password")

      friendship = Friendship.create!(user: stranger1, friend: stranger2)

      expect {
        delete friendship_path(friendship)
      }.not_to change(Friendship, :count)

      expect(flash[:alert]).to eq("Not authorized to remove this friendship.")
    end
  end

  describe "GET /friendships" do
    it "assigns incoming, outgoing, and accepted friendships" do
      incoming = Friendship.create!(user: friend, friend: user, status: :pending)
      outgoing = Friendship.create!(user: user, friend: friend, status: :pending)

      # Use a *different* user to avoid violating uniqueness validation
      other_user = User.create!(email: "c@test.com", password: "password")
      accepted   = Friendship.create!(user: user, friend: other_user, status: :accepted)

      get friendships_path

      expect(response).to have_http_status(:ok)
      expect(assigns(:incoming)).to include(incoming)
      expect(assigns(:outgoing)).to include(outgoing)
      expect(assigns(:friends)).to include(other_user)
    end
  end

  describe "GET /friendships/new" do
    it "performs case-insensitive searching" do
      upper = User.create!(email: "UPPER@test.com", first_name: "MIKE", last_name: "SMITH", password: "password")

      get new_friendship_path, params: { q: "mike" }  # lowercase search

      expect(assigns(:results)).to include(upper)
    end

    it "returns the users matching the search query" do
      match = User.create!(email: "charlie@test.com", first_name: "Charlie", last_name: "Brown", password: "password")
      no_match = User.create!(email: "zzz@test.com", first_name: "Zed", last_name: "Zebra", password: "password")

      get new_friendship_path, params: { q: "char" }
      results = assigns(:results)

      expect(results).to include(match)
      expect(results).not_to include(no_match)
      expect(results).not_to include(user)
    end

    it "returns an empty array when no search is provided" do
      get new_friendship_path
      expect(assigns(:results)).to eq([])
    end
  end
end
