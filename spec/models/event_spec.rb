require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { User.create!(email: "user@example.com", password: "password") }

  it "is valid with a name and user" do
    event = Event.new(name: "Team Meeting", user: user)
    expect(event).to be_valid
  end

  it "is invalid without a name" do
    event = Event.new(user: user)
    expect(event).not_to be_valid
  end

  it "belongs to a user" do
    assoc = Event.reflect_on_association(:user)
    expect(assoc.macro).to eq(:belongs_to)
  end
end