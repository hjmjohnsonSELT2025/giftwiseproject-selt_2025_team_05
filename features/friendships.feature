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
    Then I should see "bob@test.com" in my friends list