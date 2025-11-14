Feature: Edit profile information
  As a gift enthusiast
  I want to update my profile information
  So my profile accurately reflects me and my friends can recognize me

  Background:
    Given I am a logged in user

  Scenario: Changing profile info
    When I click "View Profile"
    And I click "Edit Profile"
    And I fill in "First name" with "Jan"
    And I fill in "Current password" with "password"
    And I click "Update"
    Then I should see "Your account has been updated successfully."
    And I should see "Hi, Jan!"