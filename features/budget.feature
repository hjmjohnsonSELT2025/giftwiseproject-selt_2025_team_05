Feature: Event Budget and Gift Claiming
  As a user
  I want my event budget enforced
  So that I don't overspend on gifts

  Background:
    Given a user "alice@test.com" exists
    And a user "bob@test.com" exists
    And I am logged in as "alice@test.com"
    And an event "Alice's Party" exists hosted by "alice@test.com"
    And "alice@test.com" has a budget of 100 for event "Alice's Party"

  Scenario: Viewing budget information on the event page
    When I go to the event page for "Alice's Party"
    Then I should see "My Budget"
    And I should see "$100.00"

  Scenario: Claiming a gift within budget
    Given a gift "Book" costing 30 exists for "bob@test.com" in "Alice's Party"
    When I go to the event page for "Alice's Party"
    And I press "Get Gifts"
    And I click "View Wishlist"
    And I click "Claim this gift"
    And I go to the event page for "Alice's Party"
    Then I should see Total Claimed of "$30.00"
    And I should see Remaining budget of "$100.00"

  Scenario: Attempting to claim a gift that exceeds remaining budget
    Given a gift "Game" costing 90 exists for "bob@test.com" in "Alice's Party"
    And a gift "Laptop" costing 20 exists for "bob@test.com" in "Alice's Party"
    And I have claimed "Game" in "Alice's Party"
    When I go to the event page for "Alice's Party"
    And I press "Get Gifts"
    And I click "View Wishlist"
    Then I should see a budget warning
    And the "Claim this gift" button should be disabled

  Scenario: Budget updates only after marking a gift as purchased
    Given a gift "Puzzle" costing 40 exists for "bob@test.com" in "Alice's Party"
    When I go to the event page for "Alice's Party"
    And I press "Get Gifts"
    And I click "View Wishlist"
    And I click "Claim this gift"
    And I go to the event page for "Alice's Party"
    Then I should see Total Claimed of "$40.00"
    And I should see Remaining budget of "$100.00"
    When I mark the gift "Puzzle" as purchased
    And I go to the event page for "Alice's Party"
    Then I should see "Remaining budget: $60.00"
