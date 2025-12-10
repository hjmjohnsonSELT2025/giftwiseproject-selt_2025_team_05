Feature: Get gift ideas for event participants
  As a gift giver
  I want a Get gift ideas option when looking at event participants
  So that I can brainstorm gift ideas within context

  Background:
    Given I am logged in as a user
    And I have an event with another participant

  Scenario: Gift ideas button opens the assistant view
    When I visit the event page
    And I click "Get Gifts"
    Then show me the page
    And I click the gift ideas button for the other participant
    Then I should be on the gift suggestions page for that participant

  Scenario: Viewing the assistant page shows context
    When I open the gift ideas page for the other participant
    Then I should see the participant's bio and wishlist
    And I should see the assistant prompt form

  Scenario: Asking the assistant shows the reply
    Given the gift assistant is stubbed to reply "Consider getting Iowa basketball home game season pass for $75."
    When I open the gift ideas page for the other participant
    And I fill in "Ask for ideas" with "Need something fun"
    And I click "Ask the assistant"
    Then I should see "Need something fun"
    And I should see "Consider getting Iowa basketball home game season pass for $75."

  Scenario: Submitting an empty prompt shows validation
    When I open the gift ideas page for the other participant
    And I click "Ask the assistant"
    Then I should see "Please enter a question before asking the assistant"