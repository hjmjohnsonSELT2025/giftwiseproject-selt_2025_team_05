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

      expect(response).to redirect_to(root_path)
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

      expect(response).to redirect_to(root_path)
    end

    it "declines a friend request" do
      patch friendship_path(request_from_friend), params: { status: "declined" }

      expect(request_from_friend.reload.status).to eq("declined")
      expect(request_from_friend.reload.status_declined?).to be(true)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE /friendships/:id" do
    let!(:friendship) { Friendship.create!(user: user, friend: friend) }

    it "destroys the friendship" do
      expect {
        delete friendship_path(friendship)
      }.to change(Friendship, :count).by(-1)

      expect(response).to redirect_to(root_path)
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
end
