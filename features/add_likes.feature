Feature: Add likes
  As a gift recipient
  I want to input my likes/dislikes
  So my friends can give me gifts I'll like

  Background:
    Given I am logged in as a user

  Scenario: Adding my interests to my bio
    When I click "View Profile"
    And I click "Edit Profile"
    And I fill in "Bio" with "UIowa Engineering 2026"
    And I fill in "Current password" with "password"
    And I click "Update"
    Then I should see "Your account has been updated successfully."
    And I click "View Profile"
    Then I should see "UIowa Engineering 2026"