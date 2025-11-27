Feature: Edit and Delete Events
  As an event owner
  I want to edit or delete my events
  So that I can keep the information up to date or remove cancelled events

  Background:
    Given I am logged in as a user
    And I have an existing event named "Annual Gala"

  Scenario: Successfully editing an event
    When I visit the event page for "Annual Gala"
    And I click "Edit"
    And I fill in "Name" with "Gala Postponed"
    And I click "Update Event"
    Then I should see "Event updated successfully!"
    And I should see "Gala Postponed"

  Scenario: Successfully deleting an event
    When I visit the event page for "Annual Gala"
    And I click "Delete"
    Then I should see "Event deleted successfully."
    And I should not see "Annual Gala" in the list of events

  Scenario: Non-owner cannot edit event
    Given there is another user named "Bob"
    And "Bob" has an event named "Bob's Birthday"
    When I visit the event page for "Bob's Birthday"
    Then I should not see "Edit"
    And I should not see "Delete"