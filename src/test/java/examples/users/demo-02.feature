Feature: browser automation 1

  Background:
    * configure driver = { type: 'chrome', webDriverSession: { browserName: 'chrome', 'goog:chromeOptions': { args: ['--window-size=300,300'] } } }

  #  * configure driver = { type: 'chrome', showDriverLog: true }
  # * configure driverTarget = { docker: 'justinribeiro/chrome-headless', showDriverLog: true }
  # * configure driverTarget = { docker: 'ptrthomas/karate-chrome', showDriverLog: true }
  # * configure driver = { type: 'chromedriver', showDriverLog: true }
  # * configure driver = { type: 'geckodriver', showDriverLog: true }
  # * configure driver = { type: 'safaridriver', showDriverLog: true }
  # * configure driver = { type: 'iedriver', showDriverLog: true, httpConfig: { readTimeout: 120000 } }
 
  Scenario:launch tests on https://demoqa.com/ to test submit text into a form
    Given driver 'https://demoqa.com/text-box'
    And waitForEnabled('#userEmail')
    When input('#userName', 'Lolo')
    When input('#userEmail', 'Lolo@lolo.com')
    When input('#currentAddress', 'Hola que ase el username es el que toca y el emanl Lolo@lolo.com')
    When input('#permanentAddress', 'Direccion drasanes 123, Barcelona')
    When click('#submit')
    Then match text('#email') contains 'Lolo@lolo.com'
  #Then match html('#email') contains '<p id="email" class="mb-1">Email:Lolo@lolo.com</p>'
  #* print 'El html del elemento es ',html('#email')
  #* print 'El text del elemento es ',text('#email')

  Scenario:launch tests on https://demoqa.com/ to check uncheck radio buttons and check the text

    # start the driver
    Given driver 'https://demoqa.com/radio-button'
    And waitForEnabled("input[id='yesRadio']")
    # click on the the YES radio button
    And click("input[id='yesRadio']")
    * print html('.text-success')
    Then match text('.text-success') contains 'Yes'
    # click on the the YES radio button
    And click("input[id='impressiveRadio']")
    #* delay(1000)
    * print html('.text-success')
    Then match text('.text-success') contains 'Impressive'
  #And match attribute("input[id='yesRadio']", 'checked') == 'true'
  #waitForText('p[class="mt-3"]', 'You have selected Yes')
  #And match text('p[class="mt-3"]') == 'You have selected Yes'

  Scenario:launch tests on https://demoqa.com/ to check uncheck checkbox

    # start the driver
    Given driver 'https://demoqa.com/checkbox'
    And waitForEnabled("input[id='tree-node-home']")
    #click on the the home checkbox
    And click("input[id='tree-node-home']")
    And match attribute("span[class='rct-checkbox']>svg", 'class') == 'rct-icon rct-icon-check'
    #Uncheck the home checkbox
    And click("input[id='tree-node-home']")
    And match attribute("span[class='rct-checkbox']>svg", 'class') == 'rct-icon rct-icon-uncheck'

  Scenario:launch tests on https://demoqa.com/ to check webTables
  
   * def valueToBeSearchedInTheTable = 'Lolo'
   * def valueToBeSearchedInTheColumn = 'Salary'
   # Start the driver and navigate to the webtables page
    Given driver 'https://demoqa.com/webtables'
    # Wait for the 'Add' button to be enabled and click on it
    And waitForEnabled("button[id='addNewRecordButton']")
    And click("button[id='addNewRecordButton']")
    # Fill in the form to add a new record to the webtable
    And input("input[id='firstName']", 'Lolo')
    And input("input[id='lastName']", 'LoloLastname')
    And input("input[id='userEmail']", 'lolo@lolo.com')
    And input("input[id='age']", '30')
    And input("input[id='salary']", '3000')
    And input("input[id='department']", 'IT')
    # Submit the form
    And click('#submit')
    # TODO: Poner un waitfor
    # --> Convert the text of the cell elements and build a json object based on the index and the text
    * def stringBodyTableLocator = "//div[@role='gridcell' and text()='"+valueToBeSearchedInTheTable+"'][last()]/parent::div[@role='row']/div[@role='gridcell']"
    * def cellElements = locateAll(stringBodyTableLocator)
    * def cellTexts = []
    * eval 
      """
        karate.forEach(
          cellElements, (cell, index) =>  {
            cellTexts.push({ index: index, text: cell.getText()});
          }
        ); 
      """
    #* print 'El celltexts -> ',cellTexts
    # XXX Fi Convert the text of the cell elements
    # --- Convert the text of the header elements and build a json object based on the index and the text
    # Get the header elements
    * def headerElements = locateAll("div[class='rt-thead -header']>div>div[role='columnheader']") 
    * def headerTexts = []
    # Build a json object based on the index and the text
    * eval 
      """
       karate.forEach(
         headerElements, (cell, index) =>  {
            headerTexts.push({ index: index, text: cell.getText()});
          }
        ); 
      """
    * print 'El headerTexs --> ',headerTexts
    # XXX Fi Convert the text of the header elements  
    # --- Search index of the first match (Salary) in the header elements
    * def searchFor = { index: '#number',text:'Salary'}
    * def foundAt = []
    * def fun = 
        """
          function(x, i){ 
          if (karate.match(x, searchFor).pass)
            karate.appendTo(foundAt, i) }
        """
    * karate.forEach(headerTexts, fun)
    * def headerIndex = foundAt[0]
    * print 'El indice de la columna es con el texto Salary es -> ',headerIndex
    # XXX Fi Search index of the first match
    # --- Search0 index of the first match in the cell elements
    * def valueInTheTable = cellTexts[headerIndex].text
    * print 'El value in the table es:', valueInTheTable
    And match valueInTheTable == '3000'



Scenario: karate find index of first match (complex)
    * def list = [{ a: 1, b: 'x'},{ a: 3, b: 'z'}, { a: 2, b: 'y'}, { a: 3, b: 'z'}]
    * def searchFor = { a: 3, b: 'z'}
    * def foundAt = []
    * def fun = 
    """
      function(x, i){ 
      if (karate.match(x, searchFor).pass)
       karate.appendTo(foundAt, i) }
    """
    
    * karate.forEach(list, fun)
    * print foundAt[0]

 