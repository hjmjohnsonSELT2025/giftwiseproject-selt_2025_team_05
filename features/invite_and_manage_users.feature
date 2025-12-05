Feature: Invite and Manage Participants
  As an event owner
  I want to invite users and remove participants
  So that I can control who attends my event

  Background:
    Given I am logged in as a user
    And I have an existing event named "Team Lunch"
    And there is another user named "Alice" with email "alice@example.com"

  Scenario: Searching and inviting a user
    When I visit the event page for "Team Lunch"
    And I fill in "Search email or name..." with "Alice"
    And I click "Search"
    Then I should see "Alice" in the search results
    When I click "Add to Event"
    Then I should see "Alice has been invited!"
    And I should see "Alice" in the participants list with status "Invited"

  Scenario: Removing a participant
    Given "Alice" is a participant in "Team Lunch"
    When I visit the event page for "Team Lunch"
    Then I should see "Alice"
    When I click "Remove"
    Then I should see "Alice has been removed from the event."
    And I should not see "Alice" in the participants list

  Scenario: Non-owner cannot search for users
    Given there is another user named "Bob"
    And "Bob" has an event named "Bob's Party"
    When I visit the event page for "Bob's Party"
    Then I should not see "Find Users to Invite"
    And I should not see field "Search email or name..."