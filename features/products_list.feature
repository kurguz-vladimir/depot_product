Feature: Products list

  Background:
    Given I am on the create product page
    And I create product with name "prod1"

  Scenario: Products list page
    Products list page
    Given I am on the products page
    And I should see header "h1"
    And I should see table with 3 columns
    And The first column should have image with class "list_image"
    And The second column should have title and description of product
    And The last column should have links:
      |Show|
      |Edit|
      |Destroy|
