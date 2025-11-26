require "rails_helper"

RSpec.describe GiftAssistant::ChatService do
  let(:client) { instance_double(OpenAI::Client) }
  let(:service) { described_class.new(model: "fake-model", client: client) }

  let(:recipient) do
    User.create!(
      email: "recipient@example.com",
      password: "password",
      first_name: "Justin",
      last_name: "Bieber",
      bio: "Singer and even rapper",
      birthdate: Date.new(2000, 6, 1)
    )
  end

  let(:event) do
    user = User.create!(email: "host@example.com", password: "password")
    user.events.create!(name: "Christmas Party")
  end

  before do
    recipient.preferences.create!(item_name: "Microphone", cost: 35, notes: "Wireless")
  end

  describe "#respond" do
    it "returns the assistant reply and passes context to OpenAI" do
      conversation = [{ role: "user", content: "Any ideas?" }]
      expected_messages = array_including(
        include(role: "system"),
        include(content: include("Event: Christmas Party")),
        include(content: include("Recipient: Justin Bieber")),
        include(content: include("Age:"))
      )

      expect(client).to receive(:chat).with(
        parameters: {
          model: "fake-model",
          messages: expected_messages
        }
      ).and_return(
        { "choices" => [ { "message" => { "content" => "How about a premium wireless microphone kit from The Audio Company? (super duper good brand)" } } ] }
      )

      reply = service.respond(
        recipient: recipient,
        event: event,
        conversation: conversation,
        prompt: "Need a gift for stage performance"
      )

      expect(reply).to eq("How about a premium wireless microphone kit from The Audio Company? (super duper good brand)")
    end

    it "falls back to an apology when the API call fails" do
      allow(client).to receive(:chat).and_raise(StandardError.new("boom"))

      reply = service.respond(
        recipient: recipient,
        event: event,
        conversation: [],
        prompt: "Help"
      )

      expect(reply).to include("Sorry")
    end
  end
end
