Feature: Add a new event
  As a registered user
  I want to create a new event
  So that I can manage and share it with others

  Background:
    Given I am logged in as a user

  Scenario: Successfully creating an event
    When I visit the new event page
    And I fill in "Name" with "Company Retreat"
    And I fill in "Address" with "123 Mountain Road"
    And I fill in "Description" with "A weekend retreat for the company team"
    And I select "Event Type" with "Friend"
    And I click "Create Event"
    Then I should see "Event created successfully!"
    And I should see "Company Retreat"
