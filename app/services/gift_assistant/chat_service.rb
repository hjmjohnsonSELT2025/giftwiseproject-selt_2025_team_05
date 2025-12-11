module GiftAssistant
  class ChatService
    SYSTEM_PROMPT = <<~PROMPT.squish
           You are GiftWise's helpful gift planning assistant. Use the recipient summary
           plus the conversation so far to propose thoughtful gift ideas. Keep answers concise,
           specific, and budget friendly when possible. Give the item, a BRIEF description, and an 
           estimate price tag. By default give 3 answers at a time, however if the user requests
           less or more, listen to the user.
         PROMPT

    def initialize(model: "gpt-4o-mini", client: OpenAI::Client.new)
      @client = client
      @model = model
    end

    # Takes the person we are shopping for, the conversation up 'this' point, and the next chat (prompt) from the user
    def respond(recipient:, event:, conversation:, prompt:, planned_gifts: [])
      response = @client.chat(
        parameters: {
          model: @model,
          messages: build_messages(
            recipient: recipient,
            event: event,
            conversation: conversation,
            prompt: prompt,
            planned_gifts: planned_gifts
          )
        }
      )

      response.dig("choices", 0, "message", "content").presence || fallback_message
    rescue StandardError => e
      Rails.logger.error("[GiftAssistant] OpenAI error: #{e.message}")
      fallback_message
    end

    private

    # Returns an array of messages. Formatted to describe a 'turn' in a conversation.
    # Used to send to the ai client to give it context about the conversation and what to respond with next
    def build_messages(recipient:, event:, conversation:, prompt:, planned_gifts: [])
      [
        { role: "system", content: SYSTEM_PROMPT },
        { role: "user", content: profile_summary(recipient, event, planned_gifts) },
        *conversation,
        { role: "user", content: prompt }
      ]
    end

    # Creates a summary of the user consisting of the specific event and user data such as age, bio, and wishlist
    def profile_summary(recipient, event, planned_gifts)
      wishlist = recipient.preferences.limit(5)
      age_text = formatted_age(recipient.birthdate)
      planned_line = if planned_gifts.present?
                       "Already planned gifts for this recipient: #{planned_gifts.join('; ')}. Please avoid suggesting these or close duplicates."
                     end
      summary = [
        "Event: #{event.name}",
        "Recipient: #{recipient.first_name} #{recipient.last_name}",
        ("Age: #{age_text}" if age_text),
        "Bio: #{recipient.bio.presence || 'Not provided'}",
        "Wishlist: #{wishlist.map { |pref| "#{pref.item_name} ($#{pref.cost})" }.join('; ').presence || 'No wishlist items yet'}",
        planned_line
      ].compact.join("\n")

      # returns the formatted string with a clear title
      "Here is the person we are brainstorming for:\n#{summary}"
    end

    # Convert birthdate into actual age
    def formatted_age(birthdate)
      return if birthdate.blank?

      today = Date.current
      age = today.year - birthdate.year
      age -= 1 if today.month < birthdate.month || (today.month == birthdate.month && today.day < birthdate.day)
      age.positive? ? age : nil
    end

    def fallback_message
      "Sorry, I failed to fetch new gift ideas. Please try again."
    end
  end
end
