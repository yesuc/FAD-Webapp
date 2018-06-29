Feature: Create a Restaurant

  Background: the website already has these restaurants
    Given these Restaurants:
    | name        | url                       | address     | cuisine  |
    | Thai Bistro | http://www.thaibistro.com/    | 1 Oak Drive | Thai     |
    | Starbucks   | http://www.starbucks.com/ | 2 Oak Drive | American |

  Scenario: Create a new Restaurant with success
    Given I am on the restaurants page
    When I follow "New Restaurant"
    Then I should be on the new restaurant page
    And I should see "Create New Restaurant"
