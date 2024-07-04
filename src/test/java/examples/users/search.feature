Feature: sample karate test ui
  for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support



  Scenario: get all elements from the search
    Given driver 'https://www.google.com'
    And input('itextarea[name="q"]', 'karate dsl')
    When click ('input[name="btnK"]')
    Then waitFor('input[name="btnK"]', 5000)