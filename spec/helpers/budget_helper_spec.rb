require 'rails_helper'

RSpec.describe BudgetHelper, type: :helper do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:event) { Event.create!(name: "Party", date: 1.day.from_now, address: "123 St", event_type: "friend", user: user) }
  let(:event_user) { EventUser.create!(event: event, user: user, budget: 100) }

  describe "#total_claimed_for" do
    it "returns 0 when user has claimed no gifts" do
      expect(helper.total_claimed_for(event, user)).to eq(0)
    end

    it "returns the sum of claimed gifts" do
      Preference.create!(giver: user, user: user, event: event, cost: 10)
      Preference.create!(giver: user, user: user, event: event, cost: 20)

      expect(helper.total_claimed_for(event, user)).to eq(30)
    end
  end

  describe "#total_purchased_for" do
    it "returns 0 when user has purchased no gifts" do
      Preference.create!(giver: user, user: user, event: event, cost: 30, purchased: false)

      expect(helper.total_purchased_for(event, user)).to eq(0)
    end

    it "returns the sum of purchased gifts" do
      Preference.create!(giver: user, user: user, event: event, cost: 10, purchased: true)
      Preference.create!(giver: user, user: user, event: event, cost: 15, purchased: true)

      expect(helper.total_purchased_for(event, user)).to eq(25)
    end
  end
end
