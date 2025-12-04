require 'rails_helper'

RSpec.describe "Home", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { User.create!(email: "host@example.com", password: "password", first_name: "Host", last_name: "User") }
  let(:other_organizer) { User.create!(email: "organizer@example.com", password: "password", first_name: "John", last_name: "Smith") }

  # Create data before each test
  before do
    sign_in user

    # Create a Future Event
    @future_event = Event.create!(name: "Future Bash", date: 1.week.from_now, address: "X", event_type: "family", user: user)
    EventUser.create!(user: user, event: @future_event, status: :joined)

    # Create a Past Event (Use save(validate: false) to bypass the 'create' validation we just added)
    @past_event = Event.new(name: "Ancient History", date: 1.week.ago, address: "Y", event_type: "family", user: user)
    @past_event.save(validate: false)
    EventUser.create!(user: user, event: @past_event, status: :joined)
  end

  describe "GET /" do
    it "shows upcoming events by default" do
      get root_path
      expect(response.body).to include("Future Bash")
      expect(response.body).not_to include("Ancient History")
    end

    it "shows upcoming events when explicitly requested" do
      get root_path(view: 'upcoming')
      expect(response.body).to include("Future Bash")
      expect(response.body).not_to include("Ancient History")
    end

    it "shows past events when view=past" do
      get root_path(view: 'past')
      expect(response.body).to include("Ancient History")
      expect(response.body).not_to include("Future Bash")
    end
  end

  describe "Search functionality" do
    before do
      # Create additional events for search testing
      @business_event = Event.create!(name: "Business Meeting", date: 2.weeks.from_now, address: "Conference Center", event_type: "business", user: user)
      EventUser.create!(user: user, event: @business_event, status: :joined)

      @friend_event = Event.create!(name: "Friend Party", date: 3.weeks.from_now, address: "Downtown Bar", event_type: "friend", user: other_organizer)
      EventUser.create!(user: user, event: @friend_event, status: :invited)
    end

    context "search by event name" do
      it "returns events matching the name query" do
        get root_path(query: "Business")
        expect(response.body).to include("Business Meeting")
        expect(response.body).not_to include("Future Bash")
        expect(response.body).not_to include("Friend Party")
      end

      it "returns events with partial name match" do
        get root_path(query: "Party")
        expect(response.body).to include("Friend Party")
        expect(response.body).not_to include("Business Meeting")
      end
    end

    context "search by address" do
      it "returns events matching the address query" do
        get root_path(query: "Conference")
        expect(response.body).to include("Business Meeting")
        expect(response.body).not_to include("Friend Party")
      end

      it "returns events with partial address match" do
        get root_path(query: "Downtown")
        expect(response.body).to include("Friend Party")
      end
    end

    context "search by organizer name" do
      it "returns events by organizer first name" do
        get root_path(query: "John")
        expect(response.body).to include("Friend Party")
        expect(response.body).not_to include("Business Meeting")
      end

      it "returns events by organizer last name" do
        get root_path(query: "Smith")
        expect(response.body).to include("Friend Party")
      end

      it "returns events by organizer full name" do
        get root_path(query: "John Smith")
        expect(response.body).to include("Friend Party")
      end
    end

    context "search with no results" do
      it "shows 'no events found' message when query matches nothing" do
        get root_path(query: "NonexistentEvent123")
        expect(response.body).to include("No events found matching your filters")
      end
    end
  end

  describe "Filter by event type" do
    before do
      @business_event = Event.create!(name: "Business Meeting", date: 2.weeks.from_now, address: "Office", event_type: "business", user: user)
      EventUser.create!(user: user, event: @business_event, status: :joined)

      @friend_event = Event.create!(name: "Friend Gathering", date: 3.weeks.from_now, address: "Cafe", event_type: "friend", user: user)
      EventUser.create!(user: user, event: @friend_event, status: :joined)
    end

    it "filters events by family type" do
      get root_path(event_type: "family")
      expect(response.body).to include("Future Bash")
      expect(response.body).not_to include("Business Meeting")
      expect(response.body).not_to include("Friend Gathering")
    end

    it "filters events by business type" do
      get root_path(event_type: "business")
      expect(response.body).to include("Business Meeting")
      expect(response.body).not_to include("Future Bash")
      expect(response.body).not_to include("Friend Gathering")
    end

    it "filters events by friend type" do
      get root_path(event_type: "friend")
      expect(response.body).to include("Friend Gathering")
      expect(response.body).not_to include("Future Bash")
      expect(response.body).not_to include("Business Meeting")
    end

    it "shows all types when no filter is applied" do
      get root_path
      expect(response.body).to include("Future Bash")
      expect(response.body).to include("Business Meeting")
      expect(response.body).to include("Friend Gathering")
    end
  end

  describe "Filter by status" do
    before do
      @invited_event = Event.create!(name: "Invited Event", date: 2.weeks.from_now, address: "Venue", event_type: "family", user: other_organizer)
      EventUser.create!(user: user, event: @invited_event, status: :invited)
    end

    it "filters events by joined status" do
      get root_path(status: "joined")
      expect(response.body).to include("Future Bash")
      expect(response.body).not_to include("Invited Event")
    end

    it "filters events by invited status" do
      get root_path(status: "invited")
      expect(response.body).to include("Invited Event")
      expect(response.body).not_to include("Future Bash")
    end

    it "shows both joined and invited events when no status filter" do
      get root_path
      expect(response.body).to include("Future Bash")
      expect(response.body).to include("Invited Event")
    end
  end

  describe "Filter by date range" do
    before do
      @near_event = Event.create!(name: "Near Event", date: 3.days.from_now, address: "Place A", event_type: "family", user: user)
      EventUser.create!(user: user, event: @near_event, status: :joined)

      @far_event = Event.create!(name: "Far Event", date: 2.months.from_now, address: "Place B", event_type: "family", user: user)
      EventUser.create!(user: user, event: @far_event, status: :joined)
    end

    it "filters events from a specific date" do
      get root_path(date_from: 1.month.from_now.to_date)
      expect(response.body).to include("Far Event")
      expect(response.body).not_to include("Near Event")
      expect(response.body).not_to include("Future Bash")
    end

    it "filters events until a specific date" do
      get root_path(date_to: 5.days.from_now.to_date)
      expect(response.body).to include("Near Event")
      expect(response.body).not_to include("Far Event")
      expect(response.body).not_to include("Future Bash")
    end

    it "filters events within a date range" do
      get root_path(date_from: 2.days.from_now.to_date, date_to: 10.days.from_now.to_date)
      expect(response.body).to include("Near Event")
      expect(response.body).to include("Future Bash")
      expect(response.body).not_to include("Far Event")
    end
  end

  describe "Combined filters" do
    before do
      @business_event = Event.create!(name: "Business Meeting", date: 2.weeks.from_now, address: "Office", event_type: "business", user: user)
      EventUser.create!(user: user, event: @business_event, status: :joined)

      @invited_business = Event.create!(name: "Business Conference", date: 3.weeks.from_now, address: "Convention", event_type: "business", user: other_organizer)
      EventUser.create!(user: user, event: @invited_business, status: :invited)
    end

    it "combines search query with type filter" do
      get root_path(query: "Meeting", event_type: "business")
      expect(response.body).to include("Business Meeting")
      expect(response.body).not_to include("Business Conference")
    end

    it "combines type filter with status filter" do
      get root_path(event_type: "business", status: "invited")
      expect(response.body).to include("Business Conference")
      expect(response.body).not_to include("Business Meeting")
    end

    it "combines all filters together" do
      get root_path(query: "Business", event_type: "business", status: "joined", date_from: Date.today, date_to: 1.month.from_now.to_date)
      expect(response.body).to include("Business Meeting")
      expect(response.body).not_to include("Business Conference")
    end

    it "preserves filters when switching between upcoming and past views" do
      # First check upcoming with filter
      get root_path(view: "upcoming", event_type: "family")
      expect(response.body).to include("Future Bash")
      expect(response.body).not_to include("Ancient History")

      # Then check past with same filter
      get root_path(view: "past", event_type: "family")
      expect(response.body).to include("Ancient History")
      expect(response.body).not_to include("Future Bash")
    end
  end

  describe "Filter UI elements" do
    it "displays the search input field" do
      get root_path
      expect(response.body).to include('name="query"')
      expect(response.body).to include("Search")
    end

    it "displays the event type filter dropdown" do
      get root_path
      expect(response.body).to include('name="event_type"')
      expect(response.body).to include("All Types")
    end

    it "displays the status filter dropdown" do
      get root_path
      expect(response.body).to include('name="status"')
      expect(response.body).to include("Joined")
      expect(response.body).to include("Invited")
    end

    it "displays the date range filters" do
      get root_path
      expect(response.body).to include('name="date_from"')
      expect(response.body).to include('name="date_to"')
    end

    it "shows Clear All button when filters are applied" do
      get root_path(query: "test")
      expect(response.body).to include("Clear All")
    end

    it "does not show Clear All button when no filters applied" do
      get root_path
      expect(response.body).not_to include("Clear All")
    end
  end
end