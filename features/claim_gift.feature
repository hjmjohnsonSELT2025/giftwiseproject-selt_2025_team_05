Feature: Claim gift
  As a gift giver
  I want to select a gift to buy for someone in the event
  So I can get them what they want

  Background:
    Given I am logged in as a user named "Bob"
    And there is another user named "Alice" with email "alice@example.com"
    And there is another user named "Judy" with email "judy@example.com"
    And "Alice" has an event named "Christmas"
    And "Bob" is a participant in "Christmas"
    And "Judy" is a participant in "Christmas"
    And "Judy" has added an item named "Bike" to their wish list

  #Scenario: Claiming a gift
    #When I click "Events"
    #And I click "View"
    #And I click "View Wish List"
    #And I click "Claim this gift"
    #Then I should see "Gift claimed successfully!"