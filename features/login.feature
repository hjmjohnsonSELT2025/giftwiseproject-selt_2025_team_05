Feature: Log in
  As a gift enthusiast
  I want to log in
  So I can coordinate my gift giving

  Background:
    Given a registered user exists

  Scenario: Visitor is forced to log in before using the app
    When I visit the home page
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing."

  Scenario: User signs in with valid credentials
    When I visit the sign in page
    And I sign in with email "dummy@example.com" and password "123456"
    Then I should be on the home page
    And I should see "Signed in successfully."

  Scenario: User enters an invalid password
    When I visit the sign in page
    And I sign in with email "dummy@example.com" and password "wrongpass"
    Then I should be on the sign in page
    And I should see "Invalid Email or password."
