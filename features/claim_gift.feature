Feature: Claim gift
  As a gift giver
  I want to select a gift to buy for someone in the event
  So I can get them what they want

  Background:
    Given I am logged in as a user named "Bob" with email "bob@example.com"
    And there is another user named "Alice" with email "alice@example.com"
    And there is another user named "Judy" with email "judy@example.com"
    And "Alice" has an event named "Christmas"
    And "Bob" is a participant in "Christmas"
    And "Judy" is a participant in "Christmas"
    And "Judy" has added an item named "Bike" to their wish list
    And "bob@example.com" has a budget of 100 for event "Christmas"

  Scenario: Claiming a gift
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "View Wishlist"
    Then show me the page
    And I click "Claim this gift"
    Then I should see "Gift claimed successfully!"