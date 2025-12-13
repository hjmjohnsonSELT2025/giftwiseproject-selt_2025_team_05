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
    And "jane@test.com" has a budget of 20 for event "Christmas"

  Scenario: Mark wishlist gift as purchased from event page
    Given "Jane" has claimed a wishlist gift called "Bike" for "Judy" in event "Christmas"
    When I visit the event page for "Christmas"
    Then show me the page
    And I check the preference purchase checkbox
    Then the purchase checkbox should be checked

  Scenario: Mark custom gift as purchased from event page
    Given "Jane" has claimed a custom gift called "Bike" for "Judy" in event "Christmas"
    When I visit the event page for "Christmas"
    Then show me the page
    And I check the suggestion purchase checkbox
    Then the suggestion checkbox should be checked

  Scenario: Mark wishlist gift as purchased from user gift summary page
    Given "Jane" has claimed a wishlist gift called "Bike" for "Judy" in event "Christmas"
    When I visit the gift summary page for "Judy" in event "Christmas"
    And I check the preference purchase checkbox
    Then the purchase checkbox should be checked

  Scenario: Mark custom gift as purchased from user gift summary page
    Given "Jane" has claimed a custom gift called "Bike" for "Judy" in event "Christmas"
    When I visit the gift summary page for "Judy" in event "Christmas"
    And I check the suggestion purchase checkbox
    Then the suggestion checkbox should be checked

  Scenario: Mark wishlist gift as unpurchased from user gift summary page
    Given "Jane" has claimed a wishlist gift called "Bike" for "Judy" in event "Christmas"
    When I visit the gift summary page for "Judy" in event "Christmas"
    And I uncheck the preference purchase checkbox
    Then the purchase checkbox should be unchecked

  Scenario: Mark custom gift as unpurchased from user gift summary page
    Given "Jane" has claimed a custom gift called "Bike" for "Judy" in event "Christmas"
    When I visit the gift summary page for "Judy" in event "Christmas"
    And I uncheck the suggestion purchase checkbox
    Then the suggestion checkbox should be unchecked


