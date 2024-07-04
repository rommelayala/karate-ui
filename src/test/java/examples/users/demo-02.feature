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
    # Utilizar scriptAll para obtener texto de todas las celdas en las filas de la tabla
    * print '-Se lanza los cellTexts:---'
    * def cellTexts = scriptAll('.rt-tr-group', '_.innerText') 
    * print '- Iterando sobre cellTexts:'
    * def validateStringInWebtable =
      """
      function(text, stringToValidate) {
        let texto = text;
        if (texto.includes(stringToValidate)) {
          console.log('Encontrado:', texto);
          return true;
        }
        if (!texto) {
          console.log('No hay texto ', texto);
          return false;
        }
        if (texto.trim() === '') {
          console.log('El texto está vacío, ', texto);
          return false;
        }
        if (isNaN(texto)) {
          console.log('El texto es NAN', texto);
          return false;
        }
      }
      """

    * eval karate.forEach(cellTexts, function(text, index) { console.log('Index:', index); validateStringInWebtable(text, 'Cierra');})
    
    # Devuelve id de la columna que contiene el texto 'Email'
    * def rowHeader = scriptAll('.rt-thead -header', '_.innerText')
    * def returnIdColumnFromText =
      """
      function(text, stringToValidate) {
      let texto = text;
      if (texto.includes(stringToValidate)) {
        console.log('Encontrado:', texto);
        return true;
      }
      if (!texto) {
        console.log('No hay texto ', texto);
        return false;
      }
      if (texto.trim() === '') {
        console.log('El texto está vacío, ', texto);
        return false;
      }
      if (isNaN(texto)) {
        console.log('El texto es NAN', texto);
        return false;
      }
      return index;
      }
      """
    * def columnIndex = -1
    * eval karate.forEach(rowHeader, function(text, index) { if (returnIdColumnFromText(text, 'Email')) { columnIndex = index; } })
    * print 'El índice de la columna que contiene el texto "email" es:', columnIndex


#* def findInColumn = read('../../resources/findInTable.js')
#* def params = { columnName: 'First Name', text: 'Lolo' }
#* def result = call findInColumn params
#Then assert result != null
#And print 'Encontrado:', result


  Scenario:launch tests on https://demoqa.com/ to check webTables
  
  Given driver 'https://demoqa.com/webtables'
    # Wait for the 'Add' button to be enabled and click on it´
    And waitForEnabled("button[id='addNewRecordButton']")
    And click('{button}Add')
    # Fill the form to add a new record to the webtable
    And input("input[id='firstName']", 'Lolo')
    And input("input[id='lastName']", 'LoloLastname')
    And input("input[id='userEmail']", 'lolo@lolo.com')
    And input("input[id='age']", '30')
    And input("input[id='salary']", '3000')
    And input("input[id='department']", 'IT')
    
    And click('{}Submit')
    #* delay(2000)
    # And match html('//div[contains(@class, "rt-tr-group")][4]//div[contains(@class, "rt-td")][5]') == '<div class="rt-td" role="gridcell" style="flex: 100 0 auto; width: 100px;">lolo@lolo.com</div>'
    * waitForText('//div[contains(@class, "rt-tr-group")][4]//div[contains(@class, "rt-td")][4]', 'lolo@lolo.com')
    * def element = locate('//div[contains(@class, "rt-tr-group")][4]//div[contains(@class, "rt-td")][4]')
    * print element

Scenario: Validatattion schema of the articles
    
    * def timeValidator = read('classpath:helpers/timeValidator.js')

    Given params {limit: 10, offset: 0}
    Given url 'https://api.realworld.io/api/'
    And path 'articles'
    When method Get
    Then status 200
    #El numero de articulos es un array de size 10
    And match response.articles == '#[10]'
    #verifica el valor del elemnto articlesCount del json
    #And match response.articlesCount == 278
    #And match response.articlesCount != 501
    #And match response == { "articles" : "##array" , "articlesCount": 251}
    #Comprueba del primer articulo el campo createdAt contenga determinado valor
    And match each response.articles ==
    """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "favorited": "#boolean",
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            }
        }
    """

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
    * print 'El celltexts -> ',cellTexts
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
    * def valueToBeSearchedInTheColumn
    * def searchFor = 
    """
      { index: '#number',
      text: 'Salary'}
    """
    
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

 