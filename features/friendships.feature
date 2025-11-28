Feature: Manage friends
  As a user
  I want to manage friendships
  So that I can connect with other users

  Background:
    Given a user "alice@test.com" exists
    And a user "bob@test.com" exists
    And I am logged in as "alice@test.com"

  Scenario: Searching for users to add
    When I go to the find friends page
    And I fill in "q" with "bob"
    And I press "Search"
    Then I should see "bob@test.com"
    And I should not see "No users found."

  Scenario: Searching with no matches
    When I go to the find friends page
    And I fill in "q" with "xyz"
    And I press "Search"
    Then I should see "No users found."

  Scenario: Sending a friend request
    When I go to the find friends page
    And I fill in "q" with "bob"
    And I press "Search"
    And I press "Add Friend"
    Then I should see "Friend request sent!"

  Scenario: Accepting a friend request
    Given "bob@test.com" has sent a friend request to "alice@test.com"
    When I go to the friends page
    And I press "Accept"
    Then I should see "bob@test.com" on the friends page

  Scenario: Declining a friend request
    Given "bob@test.com" has sent a friend request to "alice@test.com"
    When I go to the friends page
    And I press "Decline"
    Then I should see "Friend removed."

  Scenario: Removing a friend
    Given I am friends with "bob@test.com"
    When I go to the friends page
    And I press "Remove"
    Then I should see "Friend removed."

  Scenario: Visiting the friends page
    Given "bob@test.com" has sent a friend request to "alice@test.com"
    And I have sent a friend request to "bob@test.com"
    And a user "charlie@test.com" exists
    And I am friends with "charlie@test.com"
    When I go to the friends page
    Then I should see "Incoming Request" within the row for "bob@test.com"
    And I should see "Accept" within the row for "bob@test.com"
    And I should see "Decline" within the row for "bob@test.com"
    And I should see "Pending (Sent)" within the row for "bob@test.com"
    And I should see "Cancel" within the row for "bob@test.com"
    And I should see "Friend" within the row for "charlie@test.com"
    And I should see "Remove" within the row for "charlie@test.com"




