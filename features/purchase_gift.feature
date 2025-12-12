Feature: Purchase gift
  As a gift giver
  I want to mark a gift as purchased
  So I can keep track of what I've bought

  Background:
    Given I am logged in as a user named "Jane" with email "jane@test.com"
    And there is another user named "Alice" with email "alice@example.com"
    And there is another user named "Judy" with email "judy@example.com"
    And "Alice" has an event named "Christmas"
    And "Jane" is a participant in "Christmas"
    And "Judy" is a participant in "Christmas"
    And "Judy" has added an item named "Bike" to their wish list
    And "jane@test.com" has a budget of 20 for event "Christmas"

  Scenario: Mark wishlist gift as purchased from event page
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add"
    And I click "Back"
    And I check the preference purchase checkbox
    Then the purchase checkbox should be checked

  Scenario: Mark custom gift as purchased from event page
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add custom gift idea"
    And I fill in "Item Name" with "Chocolate"
    And I fill in "Cost" with "6"
    And I click "Add Custom Gift"
    And I click "Back"
    And I click "Back"
    And I check the suggestion purchase checkbox
    Then the suggestion checkbox should be checked

  Scenario: Mark wishlist gift as purchased from user gift summmary page
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add"
    And I check the preference purchase checkbox
    Then the purchase checkbox should be checked

  Scenario: Mark custom gift as purchased from user gift summary page
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add custom gift idea"
    And I fill in "Item Name" with "Chocolate"
    And I fill in "Cost" with "6"
    And I click "Add Custom Gift"
    And I click "Back"
    And I check the suggestion purchase checkbox
    Then the suggestion checkbox should be checked

  Scenario: Mark wishlist gift as unpurchased from user gift summmary page
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add"
    And I uncheck the preference purchase checkbox
    Then the purchase checkbox should be unchecked

  Scenario: Mark custom gift as unpurchased from user gift summary page
    When I click "Events"
    And I click "View"
    And I click "Get Gifts"
    And I click "Add custom gift idea"
    And I fill in "Item Name" with "Chocolate"
    And I fill in "Cost" with "6"
    And I click "Add Custom Gift"
    And I click "Back"
    And I uncheck the suggestion purchase checkbox
    Then the suggestion checkbox should be unchecked

