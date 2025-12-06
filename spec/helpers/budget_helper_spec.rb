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

  describe "#remaining_budget_for" do
    it "returns nil if event_user has no budget" do
      e_u = EventUser.create!(event: event, user: user, budget: nil)
      expect(helper.remaining_budget_for(e_u)).to be_nil
    end

    it "returns full budget when no gifts are purchased" do
      e_u = event_user
      expect(helper.remaining_budget_for(e_u)).to eq(100)
    end

    it "subtracts purchased gift total from the budget" do
      e_u = event_user
      Preference.create!(giver: user, user: user, event: event, cost: 30, purchased: true)
      Preference.create!(giver: user, user: user, event: event, cost: 20, purchased: true)
      expect(helper.remaining_budget_for(e_u)).to eq(50)
    end

    it "returns negative values if user overspends" do
      e_u = event_user
      Preference.create!(giver: user, user: user, event: event, cost: 150, purchased: true)
      expect(helper.remaining_budget_for(e_u)).to eq(-50)
    end
  end

  describe "#can_claim_gift?" do
    it "returns false when event_user does not exist" do
      event.event_users.destroy_all
      expect(helper.can_claim_gift?(event, user, 10)).to eq(false)
    end

    it "returns true when user has no budget set" do
      eu = EventUser.create!(event: event, user: user, budget: nil)
      expect(helper.can_claim_gift?(event, user, 10)).to eq(true)
    end

    it "returns true if claimed + gift_cost <= budget" do
      event_user
      Preference.create!(giver: user, user: user, event: event, cost: 30)
      expect(helper.can_claim_gift?(event, user, 20)).to eq(true)
    end

    it "returns true when claiming exactly up to the limit" do
      event_user
      Preference.create!(giver: user, user: user, event: event, cost: 50)
      expect(helper.can_claim_gift?(event, user, 50)).to eq(true)
    end

    it "returns false if claiming would exceed budget" do
      event_user
      Preference.create!(giver: user, user: user, event: event, cost: 90)
      expect(helper.can_claim_gift?(event, user, 20)).to eq(false)
    end
  end

end
