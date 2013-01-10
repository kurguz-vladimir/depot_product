Feature: Database

  Scenario: Check the types of rows in table "Products"
    We must have table with name "Product" for saving info about our products
    Given In DataBase we have table named "products" with such rows:
      |title      |
      |description|
      |image_url  |
      |price      |
    Then In table "products" should be rows with such types:
      |title 	  |string |
      |description| text  |
      |image_url  |string |
      |price	  |decimal|
