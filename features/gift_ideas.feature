Feature: Get gift ideas for event participants
  As a gift giver
  I want a Get gift ideas option when looking at event participants
  So that I can brainstorm gift ideas within context

  Background:
    Given I am logged in as a user
    And I have an event with another participant

  Scenario: Gift ideas button only appears for other participants
    When I visit the event page
    Then I should see a gift ideas button for the other participant
    And I should not see a gift ideas button for myself

  Scenario: Gift ideas button opens the assistant view
    When I visit the event page
    And I click the gift ideas button for the other participant
    Then I should be on the gift suggestions page for that participant
