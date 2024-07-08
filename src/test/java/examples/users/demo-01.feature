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


  Scenario: try to login https://practicetestautomation.com/practice-test-login/
    
    Given driver 'https://practicetestautomation.com/practice-test-login/'
    And input('#username', 'student')
    And input('#password', 'Password123')
    When click("#submit")
    # Usando class para encontrar elementos
    * print "Usando class para encontrar elementos"
    Then waitFor('.post-title') 
    And match text('.post-title') == 'Logged In Successfully'
    * print "Success test using class selector"
    # Usando Css selector para encontrar elementos
    * print "Usando CSS para encontrar elementos"
    Then waitFor('h1.post-title')         // Usando elemento y clase selector
    And match text('h1.post-title') == 'Logged In Successfully' 
    * print "Success test using CSS selector"


  Scenario:launch tests on ultimateqa.com/filling-out-forms/ form without captcha
    Given driver 'https://ultimateqa.com/filling-out-forms/'
    And waitForEnabled('#et_pb_contact_name_0')
    And match driver.title == 'Filling Out Forms - Ultimate QA'
    # And driver.dimensions = { x: 0, y: 0, width: 300, height: 300 }
    And input('input[name=et_pb_contact_name_0]', 'test input')
    And input('#et_pb_contact_message_0', 'esto es una prueba de rellenar formularios')
    #Haciendo click a elemetos por css
    When click('button[name=et_builder_submit_button]')
    And waitForText('#et_pb_contact_form_0', 'Thanks for contacting us')
    #And match text('#et_pb_contact_form_0 .et-pb-contact-message p') == 'Thanks for contacting us'
    And match text('#et_pb_contact_form_0 ') == 'Thanks for contacting us'
    And match attribute('#et_pb_contact_form_0', 'style') == 'opacity: 1;'


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

    # Print all cell texts of the last row to verify
    # Utilizar scriptAll para obtener texto de todas las celdas en las filas de la tabla
    * print '-Se lanza los cellTexts:---'
    * def cellTexts = scriptAll('.rt-tr-group', '_.innerText')
    # * print '-Vaya cellTexts:', cellTexts
    #* eval karate.forEach(cellTexts, function(text){ console.log('///',text) })
    #* print '-Fin de los cellTexts:---'
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

    * eval karate.forEach(cellTexts, function(text) { validateStringInWebtable(text, 'Cierra') })

#* def findInColumn = read('../../resources/findInTable.js')
#* def params = { columnName: 'First Name', text: 'Lolo' }
#* def result = call findInColumn params
#Then assert result != null
#And print 'Encontrado:', result






