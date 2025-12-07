Feature: Search and filter events on home page
  As a registered user
  I want to search and filter my events
  So that I can quickly find specific events

  Background:
    Given I am logged in as a user named "Alice"

  Scenario: Search events by name
    Given the following events exist:
      | name            | date_offset | status |
      | Birthday Party  | 7           | joined |
      | Business Meeting| 14          | joined |
      | Family Reunion  | 21          | joined |
    When I visit the home page
    And I fill in "query" with "Birthday"
    And I click "Apply Filters"
    Then I should see "Birthday Party"
    And I should not see "Business Meeting"
    And I should not see "Family Reunion"

  Scenario: Search events by address
    Given there is another user named "Bob"
    And "Bob" has an event named "Downtown Gala" at address "123 Main Street"
    And I have been invited to "Downtown Gala"
    When I visit the home page
    And I fill in "query" with "Main Street"
    And I click "Apply Filters"
    Then I should see "Downtown Gala"

  Scenario: Search events by organizer name
    Given there is another user named "Charlie"
    And "Charlie" has an event named "Charlie's Party"
    And I have been invited to "Charlie's Party"
    When I visit the home page
    And I fill in "query" with "Charlie"
    And I click "Apply Filters"
    Then I should see "Charlie's Party"

  Scenario: Filter events by type - Family
    Given the following events exist:
      | name           | date_offset | status | event_type |
      | Family Dinner  | 7           | joined | family     |
      | Work Party     | 14          | joined | business   |
    When I visit the home page
    And I select "event_type" with "Family"
    And I click "Apply Filters"
    Then I should see "Family Dinner"
    And I should not see "Work Party"

  Scenario: Filter events by type - Business
    Given the following events exist:
      | name           | date_offset | status | event_type |
      | Family Dinner  | 7           | joined | family     |
      | Work Party     | 14          | joined | business   |
    When I visit the home page
    And I select "event_type" with "Business"
    And I click "Apply Filters"
    Then I should see "Work Party"
    And I should not see "Family Dinner"

  Scenario: Filter events by status - Joined only
    Given there is another user named "Dave"
    And "Dave" has an event named "Dave's Birthday"
    And I have been invited to "Dave's Birthday"
    And I have an existing event named "My Event"
    And I have joined "My Event"
    When I visit the home page
    And I select "status" with "Joined"
    And I click "Apply Filters"
    Then I should see "My Event"
    And I should not see "Dave's Birthday"

  Scenario: Filter events by status - Invited only
    Given there is another user named "Eve"
    And "Eve" has an event named "Eve's Party"
    And I have been invited to "Eve's Party"
    And I have an existing event named "My Own Event"
    And I have joined "My Own Event"
    When I visit the home page
    And I select "status" with "Invited"
    And I click "Apply Filters"
    Then I should see "Eve's Party"
    And I should not see "My Own Event"

  Scenario: Filter events by date range
    Given the following events exist:
      | name         | date_offset | status |
      | Soon Event   | 3           | joined |
      | Later Event  | 60          | joined |
    When I visit the home page
    And I fill in "date_to" with a date 10 days from now
    And I click "Apply Filters"
    Then I should see "Soon Event"
    And I should not see "Later Event"

  Scenario: Combine search and type filter
    Given the following events exist:
      | name              | date_offset | status | event_type |
      | Family Picnic     | 7           | joined | family     |
      | Work Conference   | 14          | joined | business   |
      | Friend Hangout    | 21          | joined | friend     |
    When I visit the home page
    And I fill in "query" with "Family"
    And I select "event_type" with "Family"
    And I click "Apply Filters"
    Then I should see "Family Picnic"
    And I should not see "Work Conference"
    And I should not see "Friend Hangout"

  Scenario: Clear all filters
    Given the following events exist:
      | name            | date_offset | status |
      | Birthday Party  | 7           | joined |
      | Business Meeting| 14          | joined |
    When I visit the home page
    And I fill in "query" with "Birthday"
    And I click "Apply Filters"
    Then I should see "Birthday Party"
    And I should not see "Business Meeting"
    When I click "Clear All"
    Then I should see "Birthday Party"
    And I should see "Business Meeting"

  Scenario: No events found with filters
    Given the following events exist:
      | name            | date_offset | status |
      | Birthday Party  | 7           | joined |
    When I visit the home page
    And I fill in "query" with "NonexistentEvent"
    And I click "Apply Filters"
    Then I should see "No events found matching your filters"

  Scenario: Filters persist when switching between upcoming and past views
    Given the following events exist:
      | name              | date_offset | status | event_type |
      | Upcoming Family   | 7           | joined | family     |
      | Upcoming Business | 14          | joined | business   |
      | Past Family       | -7          | joined | family     |
      | Past Business     | -14         | joined | business   |
    When I visit the home page
    And I select "event_type" with "Family"
    And I click "Apply Filters"
    Then I should see "Upcoming Family"
    And I should not see "Upcoming Business"
    When I click the "Past Events" link
    Then I should see "Past Family"
    And I should not see "Past Business"

