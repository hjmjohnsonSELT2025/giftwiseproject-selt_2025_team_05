require "rails_helper"

RSpec.describe GiftHistoryService, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) {User.create!(email: "giver@example.com", password: "password", first_name: "Giver", last_name: "User")}
  let(:friend) {User.create!(email: "recipient@example.com", password: "password", first_name: "Recipient", last_name: "User")}
  let(:upcoming_event) do
    user.events.create!(
      name: "Upcoming Event",
      date: 2.days.from_now,
      address: "123 Main St",
      description: "Soon",
      event_type: "friend"
    )
  end
  let(:past_event) do
    user.events.create!(
      name: "Past Event",
      date: 1.day.from_now, # valid at creation time
      address: "456 Main St",
      description: "Already happened",
      event_type: "friend"
    )
  end

  before do
    EventUser.create!(event: upcoming_event, user: user, status: :joined)
    EventUser.create!(event: upcoming_event, user: friend, status: :joined)

    EventUser.create!(event: past_event, user: user, status: :joined)
    EventUser.create!(event: past_event, user: friend, status: :joined)
  end

  describe "#fetch" do
    before do
      #Upcoming preference/suggestions
      Preference.create!(event: upcoming_event, user: friend, giver_id: user.id, item_name: "Upcoming Preference", purchased: false)
      Suggestion.create!(event: upcoming_event, recipient_id: friend.id, user_id: user.id, item_name: "Upcoming Suggestion", purchased: false)

      #Purchased preference
      Preference.create!(event: past_event, user: friend, giver_id: user.id, item_name: "Purchased Preference", purchased: true)

      #Unpurchased preference
      Preference.create!(event: past_event, user: friend, giver_id: user.id, item_name: "Unpurchased Preference", purchased: false)

      #Purchased suggestion
      Suggestion.create!(event: past_event, recipient_id: friend.id, user_id: user.id, item_name: "Purchased Suggestion", purchased: true)
    end

    it "includes all relevant gifts for upcoming events" do
      travel_to Time.zone.today do
        upcoming, _ = described_class.new(user, friend).fetch
        names = upcoming.map(&:item_name)

        expect(names).to include("Upcoming Preference", "Upcoming Suggestion")
      end
    end

    it "includes only purchased gifts for past events" do
      travel_to 2.days.from_now do
        _, past = described_class.new(user, friend).fetch
        names = past.map(&:item_name)

        expect(names).to include("Purchased Preference", "Purchased Suggestion")
        expect(names).not_to include("Unpurchased Preference")
      end
    end
  end

  describe "#has_history?" do
    it "returns true when upcoming gifts exist" do
      Preference.create!(
        event: upcoming_event,
        user: friend,
        giver_id: user.id,
        item_name: "Upcoming Preference",
        purchased: false
      )

      travel_to Time.zone.today do
        expect(described_class.new(user, friend).has_history?).to be true
      end
    end

    it "returns true when purchased past gifts exist" do
      Preference.create!(
        event: past_event,
        user: friend,
        giver_id: user.id,
        item_name: "Purchased Preference",
        purchased: true
      )

      travel_to 2.days.from_now do
        expect(described_class.new(user, friend).has_history?).to be true
      end
    end

    it "returns false when only unpurchased past gifts exist" do
      Preference.create!(
        event: past_event,
        user: friend,
        giver_id: user.id,
        item_name: "Unpurchased Preference",
        purchased: false
      )

      travel_to 2.days.from_now do
        expect(described_class.new(user, friend).has_history?).to be false
      end
    end

    it "returns false when users share no events" do
      EventUser.destroy_all
      expect(described_class.new(user, friend).has_history?).to be false
    end
  end
end