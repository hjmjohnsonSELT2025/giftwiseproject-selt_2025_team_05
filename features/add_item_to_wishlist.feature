Feature: Add an item to my wishlist
  As a registered user
  I want to add an item to my wishlist
  So people know what I want to get

  Background:
    Given I am a user logged in

  Scenario: Adding an item to my wishlist
    When I visit the wishlist page
    And I click "Add New Item"
    And I fill in "Item Name" with "Barbie"
    And I fill in "Cost" with "20"
    And I fill in "Notes" with "Doll"
    And I click "Add to Wishlist"
    Then I should see "Item added to wish list!"
