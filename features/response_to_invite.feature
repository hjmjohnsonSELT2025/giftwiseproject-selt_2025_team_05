Feature: Respond to Invites and Leave Events
  As a guest user
  I want to accept or decline invitations and leave events
  So that I can manage my schedule

  Background:
    Given I am logged in as a user named "John"
    And there is another user named "Host"
    And "Host" has created an event named "Networking Night"

  Scenario: Accepting an invitation
    Given I have been invited to "Networking Night"
    When I visit the home page
    Then I should see "Networking Night"
    And I should see "Pending Invite"
    When I click "Accept"
    Then I should see "You have successfully joined the event!"
    And I should see "Joined" within the "Networking Night" row

  Scenario: Declining an invitation
    Given I have been invited to "Networking Night"
    When I visit the home page
    Then I should see "Networking Night"
    When I click "Decline"
    Then I should see "You have declined the invitation."
    And I should not see "Networking Night" within the upcoming events table

  Scenario: Leaving an event I previously joined
    Given I have joined "Networking Night"
    When I visit the event page for "Networking Night"
    Then I should see "Leave Event"
    When I click "Leave Event"
    Then I should see "You have left the event."
    And I should not see "Leave Event"