Feature: Log out
  As a gift enthusiast
  I want to log out
  So no one else can access my account info

  Background:
    Given a user is signed in

  Scenario: Signing out from the home page
    When I click "Sign out"
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing."