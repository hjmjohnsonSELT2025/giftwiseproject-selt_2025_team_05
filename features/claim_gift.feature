Feature: Claim gift
  As a gift giver
  I want to select a gift to buy for someone in the event
  So I can get them what they want

  Background:
    Given I am logged in as a user named "Jane" with email "jane@test.com"
    And there is another user named "Alice" with email "alice@example.com"
    And there is another user named "Judy" with email "judy@example.com"
    And "Alice" has an event named "Christmas"
    And "Jane" is a participant in "Christmas"
    And "Judy" is a participant in "Christmas"
    And "Judy" has added an item named "Bike" to their wish list
    And "jane@test.com" has a budget of 20 for event "Christmas"

  Scenario: Claiming a gift
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add"
    Then I should see "Gift claimed successfully!"

  Scenario: Unclaiming a gift
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add"
    And I click "Remove Wishlist Gift"
    Then I should see "Gift unclaimed successfully!"

  Scenario: Add custom gift
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add custom gift idea"
    And I fill in "Item Name" with "Chocolate"
    And I fill in "Cost" with "6"
    And I click "Add Custom Gift"
    Then I should see "Gift suggestion added!"
    Then I should see "Chocolate"
