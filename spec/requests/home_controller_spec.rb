require 'rails_helper'

RSpec.describe "Home", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { User.create!(email: "host@example.com", password: "password", first_name: "Host", last_name: "User") }

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
end