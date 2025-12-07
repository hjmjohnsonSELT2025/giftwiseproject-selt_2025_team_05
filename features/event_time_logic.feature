Feature: Event Time Logic
  As a user
  I want to separate past and upcoming events
  And prevent creating past events
  So that my schedule is organized and accurate

  Background:
    Given I am logged in as a user
    And the following events exist:
      | name           | date_offset | status |
      | Upcoming Party | 5           | joined |
      | Past Reunion   | -5          | joined |

  Scenario: Toggling between Past and Upcoming events
    When I visit the home page
    Then I should see "Upcoming Party"
    And I should not see "Past Reunion"

    When I click the "Past Events" link
    Then I should see "Past Reunion"
    And I should not see "Upcoming Party"
    And "Past Reunion" should have a dimmed style

  Scenario: User cannot create an event in the past
    When I visit the new event page
    And I fill in "Name" with "Impossible Event"
    # Filling in a date from last year
    And I fill in "Date" with "2020-01-01T12:00"
    And I fill in "Address" with "123 Test Lane"
    And I click "Create Event"
    Then I should see "Date can't be in the past"

  Scenario: Past events are read-only
    # Accessing the past event created in Background
    When I click the "Past Events" link
    And I click "View" for "Past Reunion"
    Then I should see "Past Reunion"
    And I should see "Past Event" badge
    # Check that actions are hidden
    And I should not see button "Edit"
    And I should not see button "Delete"
    And I should not see "Find Users to Invite"
    And I should not see "Get gift ideas"