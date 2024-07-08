@debug
Feature: browser automation with tables

    Background:
        * configure driver = { type: 'chrome', webDriverSession: { browserName: 'chrome', 'goog:chromeOptions': { args: ['--window-size=300,300'] } } }

    #  * configure driver = { type: 'chrome', showDriverLog: true }
    # * configure driverTarget = { docker: 'justinribeiro/chrome-headless', showDriverLog: true }
    # * configure driverTarget = { docker: 'ptrthomas/karate-chrome', showDriverLog: true }
    # * configure driver = { type: 'chromedriver', showDriverLog: true }
    # * configure driver = { type: 'geckodriver', showDriverLog: true }
    # * configure driver = { type: 'safaridriver', showDriverLog: true }
    # * configure driver = { type: 'iedriver', showDriverLog: true, httpConfig: { readTimeout: 120000 } }


    #*
    # Scenario: Define a simple table and print the values
    #
    # This scenario demonstrates how to define a simple table and print its values.
    #
    # Steps:
    # 1. Define a table named "users" with columns "id", "name", and "age".
    # 2. Populate the table with three rows of data.
    # 3. Print the values of the "users" table.
    #
    # Example:
    # | id | name   | age |
    # | 1  | 'John' | 30  |
    # | 2  | 'Alice'| 25  |
    # | 3  | 'Bob'  | 28  |
    #
    # Usage:
    # Given a simple table is defined with the following data:
    #   | id | name   | age |
    #   | 1  | 'John' | 30  |
    #   | 2  | 'Alice'| 25  |
    #   | 3  | 'Bob'  | 28  |
    # When the table is printed
    # Then the values of the table should be displayed
    #/

    Scenario: Define a simple table and print the values
        * table users
            | id | name    | age |
            | 1  | 'John'  | 30  |
            | 2  | 'Alice' | 25  |
            | 3  | 'Bob'   | 28  |


        * def featureTable = users
        * print 'La variable featureTable -> ', featureTable


    Scenario: Extract and convert HTML table and print the values in Json format
        Given url 'https://the-internet.herokuapp.com/tables'
        When method get
        Then status 200
        And def html = response

        * def extractTableFromHTML =
            """
            function(html) {
            var Jsoup = Java.type('org.jsoup.Jsoup');
            var doc = Jsoup.parse(html);
            var table = doc.getElementById('table1');
            var headers = table.select('th').eachText();
            var rows = table.select('tr');
            var data = [];

            // skip header row
            for (var i = 1; i < rows.size(); i++) {
            var cells = rows.get(i).select('td');
            var row = {};
            for (var j = 0; j < cells.size(); j++) {
            row[headers.get(j)] = cells.get(j).text();
            }
            data.push(row);
            }
            return data;
            }
            """

        * def tableData = call extractTableFromHTML html
        * def users = tableData
        * print users
    
    Scenario: 
        Given driver 'https://www.saucedemo.com/'
        And input("#user-name", "standard_user")
        And input("#password", "secret_sauce")
        When click("#login-button")
        Then match text(".title") == "Products"
        And match text(".app_logo") == "Swag Labs"
        And waitForEnabled("#inventory_container").click()
        #Un elemento esta presente
        And assert optional('#inventory_container').present
        * def inventoryItems = locateAll(".inventory_item")
        And  assert inventoryItems.length > 0
        * print 'Number of inventory items:', inventoryItems.length