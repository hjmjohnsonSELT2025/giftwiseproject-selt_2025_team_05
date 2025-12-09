Feature: Clone an existing event
  As an event organizer
  I want to clone an existing event
  So that I can quickly create similar events without re-entering all the details

  Background:
    Given I am logged in as a user named "Alice"
    And I have a friend named "Bob Smith"

  Scenario: Successfully cloning an event with pre-filled details
    Given I have an existing event named "Birthday Party"
    And "Bob Smith" has been invited to "Birthday Party"
    When I visit the event page for "Birthday Party"
    And I click "Clone"
    Then I should see "Create a New Event"
    And the "Name" field should contain "Birthday Party (Clone)"
    And the "Address" field should contain "123 Main St"
    And "Bob Smith" should be checked in the friends list

  Scenario: Clone button is visible for past events
    Given I have a past event named "Last Year Party"
    When I visit the event page for "Last Year Party"
    Then I should see "Clone"

  Scenario: Cloning and submitting creates a new event
    Given I have an existing event named "Weekly Meeting"
    When I visit the event page for "Weekly Meeting"
    And I click "Clone"
    And I fill in "Date" with "2030-06-15T14:00"
    And I click "Create Event"
    Then I should see "Event created successfully!"
    And I should see "Weekly Meeting (Clone)"

  Scenario: Clone preserves event type
    Given I have an existing family event named "Family Reunion"
    When I visit the event page for "Family Reunion"
    And I click "Clone"
    Then the "Event Type" field should have "Family" selected


