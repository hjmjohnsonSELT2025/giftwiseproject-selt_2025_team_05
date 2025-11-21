require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user)  { User.create!(email: "a@test.com", password: "password") }
  let(:friend) { User.create!(email: "b@test.com", password: "password") }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name("User") }
  end

  describe "validations" do
    it "prevents duplicate friendships" do
      Friendship.create!(user: user, friend: friend)

      duplicate = Friendship.new(user: user, friend: friend)
      expect(duplicate.valid?).to be(false)
    end

    it "prevents a user from friending themself" do
      friendship = Friendship.new(user: user, friend: user)
      expect(friendship.valid?).to be(false)
      expect(friendship.errors[:friend_id]).to include("can't be the same as user")
    end
  end

  describe "enum status" do
    it "has the correct enum values" do
      expect(Friendship.statuses).to eq(
                                       {
                                         "pending"  => "pending",
                                         "accepted" => "accepted",
                                         "declined" => "declined",
                                         "blocked"  => "blocked"
                                       }
                                     )
    end

    it "supports enum helper methods" do
      f = Friendship.create!(user: user, friend: friend)
      expect(f.status_pending?).to be(true)

      f.status_accepted!
      expect(f.status_accepted?).to be(true)

      f.status_declined!
      expect(f.status_declined?).to be(true)
    end
  end
end
