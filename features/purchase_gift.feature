Feature: Purchase gift
  As a gift giver
  I want to mark a gift as purchased
  So I can keep track of what I've bought

  Background:
    Given there is another user named "Alice" with email "alice@example.com"
    And there is another user named "Judy" with email "judy@example.com"
    And "Alice" has an event named "Christmas"
    And "Judy" is a participant in "Christmas"

  @javascript
  Scenario: Mark wishlist gift as purchased from event page
    Given I am logged in as a user using Warden named "Jane" with email "jane@test.com"
    And "Jane" is a participant in "Christmas"
    And "jane@test.com" has a budget of 20 for event "Christmas"
    Given "Jane" has claimed a wishlist gift called "Bike" for "Judy" in event "Christmas"
    When I visit the event page for "Christmas"
    And I check the preference purchase checkbox
    And the purchase status of "Bike" should be "true"

  @javascript
  Scenario: Mark custom gift as purchased from event page
    Given I am logged in as a user using Warden named "Bob" with email "bob@test.com"
    And "Bob" is a participant in "Christmas"
    And "bob@test.com" has a budget of 20 for event "Christmas"
    Given "Bob" has claimed a custom gift called "Bike" for "Judy" in event "Christmas"
    When I visit the event page for "Christmas"
    And I check the suggestion purchase checkbox
    And the purchase status of "Bike" should be "true"

  @javascript
  Scenario: Mark wishlist gift as purchased from user gift summary page
    Given I am logged in as a user using Warden named "Jane" with email "jane@test.com"
    And "Jane" is a participant in "Christmas"
    And "jane@test.com" has a budget of 20 for event "Christmas"
    Given "Jane" has claimed a wishlist gift called "Bike" for "Judy" in event "Christmas"
    When I visit the gift summary page for "Judy" in event "Christmas"
    And I check the preference purchase checkbox
    And the purchase status of "Bike" should be "true"

  @javascript
  Scenario: Mark custom gift as purchased from user gift summary page
    Given I am logged in as a user using Warden named "Jane" with email "jane@test.com"
    And "Jane" is a participant in "Christmas"
    And "jane@test.com" has a budget of 20 for event "Christmas"
    Given "Jane" has claimed a custom gift called "Bike" for "Judy" in event "Christmas"
    When I visit the gift summary page for "Judy" in event "Christmas"
    And I check the suggestion purchase checkbox
    And the purchase status of "Bike" should be "true"

  @javascript
  Scenario: Mark wishlist gift as unpurchased from user gift summary page
    Given I am logged in as a user using Warden named "Jane" with email "jane@test.com"
    And "Jane" is a participant in "Christmas"
    And "jane@test.com" has a budget of 20 for event "Christmas"
    Given "Jane" has claimed a wishlist gift called "Bike" for "Judy" in event "Christmas"
    When I visit the gift summary page for "Judy" in event "Christmas"
    And I uncheck the preference purchase checkbox
    And the purchase status of "Bike" should be "false"

  @javascript
  Scenario: Mark custom gift as unpurchased from user gift summary page
    Given I am logged in as a user using Warden named "Jane" with email "jane@test.com"
    And "Jane" is a participant in "Christmas"
    And "jane@test.com" has a budget of 20 for event "Christmas"
    Given "Jane" has claimed a custom gift called "Bike" for "Judy" in event "Christmas"
    When I visit the gift summary page for "Judy" in event "Christmas"
    And I uncheck the suggestion purchase checkbox
    Then the suggestion checkbox should be unchecked
    And the purchase status of "Bike" should be "false"



