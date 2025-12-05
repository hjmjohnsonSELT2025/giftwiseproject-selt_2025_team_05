require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { User.create(email: "test@example.com", password: "password", first_name: "Test", last_name: "User") }

  describe "validations" do
    it "is valid with a future date" do
      event = Event.new(
        name: "Future Party",
        date: 1.day.from_now,
        address: "123 Main St",
        event_type: "family",
        description: "Fun time",
        user: user
      )
      expect(event).to be_valid
    end

    # 2. Test the Failure Path (Past Date)
    it "is invalid with a past date on create" do
      event = Event.new(
        name: "Past Party",
        date: 1.day.ago,
        address: "123 Main St",
        event_type: "family",
        description: "Time machine",
        user: user
      )

      expect(event).not_to be_valid
      expect(event.errors[:date]).to include("can't be in the past")
    end

    # 3. Edge Case: Updating existing events
    # (Optional) Ensure we can still edit an event that has naturally passed
    it "allows updating an event even if the date is now in the past" do
      # Create a valid future event
      event = Event.create!(
        name: "Meeting",
        date: 1.day.from_now,
        address: "Office",
        event_type: "family",
        user: user
      )

      # Fast forward time or manually set date to past without triggering 'create' validation
      # We rely on the model validation having `on: :create`
      event.date = 1.day.ago

      # It should still be valid because we are updating, not creating
      expect(event).to be_valid
    end
  end

  describe "associations" do
    it "belongs to a user" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it "has many event_users" do
      association = described_class.reflect_on_association(:event_users)
      expect(association.macro).to eq :has_many
    end
  end
end