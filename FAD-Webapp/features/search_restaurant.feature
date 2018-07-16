Feature: Search Restaurants
  As a User,
  so that I can find Restaurants that have foods fitting my dietary restrictions and are within my distance,
  I want to be able to search for Restaurants with a name, url, a distance, and with my allergens

  Background: the website already has these restaurants
    Given these Restaurants:
    | name        | url                                   | address                            | cuisine  | description                      |
    | Thai Bistro | http://www.thaibistro.com/            | 11 Oak Drive, Hamilton             | Thai     | A Thai Bistro                    |
    | Starbucks   | http://www.starbucks.com/             | 12 Oak Drive, Hamilton             | American | American Coffee Chain            |
    | Frank       | https://www.dineoncampus.com/colgate/ | 13 Oak Drive, Hamilton             | American | Colgate University's dining hall |
    | Red Samurai | http://redsamurainh.com/              | 8562 Seneca Turnpike, New Hartford | Asian    | Japanese Restaurant              |

  Scenario: Search for a Restaurant
    Given I am on the home page
    When I check "shellfish"
    And I check "egg"
    And I check "soy"
    And I query ""
    Then I should be on the search results page
    And I should see "Search Results for ''"
    And the "shellfish" checkbox should be checked
    And the "egg" checkbox should be checked
    And the "soy" checkbox should be checked
    And the "searchbar" field should contain ""
    And the "query_type" field should contain "name"
    And the "query_distance" field should contain "5"

  Scenario: Order Restaurant Query Results by best match
    Given I am on the home page
    When I check "treenuts"
    And I check "pork"
    And I check "beef"
    When I query ""
    Then I should be on the search results page
    And I should see "Search Results for ''"
    And the "treenuts" checkbox should be checked
    And the "pork" checkbox should be checked
    And the "beef" checkbox should be checked
    And the "searchbar" field should contain ""
    And the "query_type" field should contain "name"
    And the "query_distance" field should contain "5"
    And I should see a link titled "Best Match"
    When I follow "Best Match"
    Then I should be on the search results page
    And I should see "Search Results for ''"
    And the "treenuts" checkbox should be checked
    And the "pork" checkbox should be checked
    And the "beef" checkbox should be checked
    And the "searchbar" field should contain ""
    And the "query_type" field should contain "name"
    And the "query_distance" field should contain "5"
    And each Restaurant should be ordered by best match

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

  Scenario: Make multiple Queries and order by multiple preferences
