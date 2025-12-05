Feature: Invite Friends to Events
  As a user
  I want to easily invite friends when creating an event or viewing it
  So that I can organize gatherings quickly

  Background:
    Given I am logged in as a user named "Host"
    And I have a friend named "Alice Friend"
    And I have a friend named "Bob Stranger"

  Scenario: Creating an event and selecting friends immediately
    When I visit the new event page
    And I fill in "Name" with "Birthday Bash"
    And I fill in "Date" with "2030-01-01T19:00"
    And I fill in "Address" with "123 Party Lane"
    And I check "Alice Friend"
    And I click "Create Event"

    Then I should see "Event created successfully!"
    And I should see "Birthday Bash"
    # Verify Participant List
    And I should see "Alice Friend" in the participants list
    And I should see "Invited" next to "Alice Friend"
    And I should not see "Bob Stranger" in the participants list

  Scenario: Inviting a friend from the Event Show page
    Given I have an existing event named "Casual Dinner"
    When I visit the event page for "Casual Dinner"
    # Testing the default list in Show page
    Then I should see "Alice Friend" within the invite suggestions

    When I click "Add to Event" for user "Alice Friend"
    Then I should see "Alice Friend" in the participants list
    And I should see "Invited" next to "Alice Friend"
    # Should disappear from suggestions once added
    And I should not see "Alice Friend" within the invite suggestions