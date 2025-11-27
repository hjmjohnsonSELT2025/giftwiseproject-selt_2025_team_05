Feature: Log out
  As a gift enthusiast
  I want to log out
  So no one else can access my account info

  Background:
    Given I am logged in as a user

  Scenario: Signing out from the home page
    When I click "Sign out"
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing."