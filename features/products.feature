Feature: Products manage

  Background:
    Given I am on the create product page
    And I create product with name "prod1"

  Scenario: Creating product
    Creating product
    Given I am on the create product page
    And On the page must be textarea with name "product[description]" and height 6 rows
    When I create product with name "prod2"
    Then I should be redirected on the product page with name "prod2"
    And I should see product title "title: prod2"

  Scenario: Updating product
    Updating product
    Given I am on the product page
    When I follow "Edit"
    And I update product with new name "new prod1"
    Then I should be redirected on the product page with name "new prod1"
    And I should see product title "title: new prod1"

  Scenario: Deleting product
    Deleting product
    Given I go to the products page
    When I destroy product with name "prod1"
    Then I should be redirected on the products page
    And I should not see product with name "prod1"
