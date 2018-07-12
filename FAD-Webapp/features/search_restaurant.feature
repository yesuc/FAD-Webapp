Feature: Create a Restaurant

  Background: the website already has these restaurants
    Given these Restaurants:
    | name        | url                                   | address                            | cuisine  | description                      |
    | Thai Bistro | http://www.thaibistro.com/            | 11 Oak Drive, Hamilton             | Thai     | A Thai Bistro                    |
    | Starbucks   | http://www.starbucks.com/             | 12 Oak Drive, Hamilton             | American | American Coffee Chain            |
    | Frank       | https://www.dineoncampus.com/colgate/ | 13 Oak Drive, Hamilton             | American | Colgate University's dining hall |
    | Red Samurai | http://redsamurainh.com/              | 8562 Seneca Turnpike, New Hartford | Asian    | Japanese Restaurant              |


  Scenario: Order Restaurant Query Results by best match
    Given I am on the home page
    When I query ""
    Then I should be on the search results page
    And I should see results "Search Results for ''"
    And I should see a link titled "Best Match"
    When I follow "Best Match"
    Then each Restaurant should be ordered by best match

  Scenario: Order Restaurant Query Results by name
    Given I am on the home page
    When I query ""
    Then I should be on the search results page
    And I should see "Search Results for ''"
    And I should see a link titled "Name"
    When I follow "Name"
    Then each Restaurant should be ordered by name

  Scenario: Order Restaurant Query Results by distance
    Given I am on the home page
    When I query ""
    Then I should be on the search results page
    And I should see "Search Results for ''"
    And I should see a link titled "Distance"
    When I follow "Distance"
    Then each Restaurant should be ordered distance
