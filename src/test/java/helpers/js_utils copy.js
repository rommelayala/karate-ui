function find(text) {
    let rows = locateAll('.rt-tr-group');

    console.log('Rows:', rows);
    let count = rows.length;
    if (count) {
        for (let i = 0; i < count; i++) {
            let e = rows[i];
            let rowText = e.script('_.textContent');
            console.log('El texto del row es...', rowText)
            if (rowText.includes(text)) {
                // Suponiendo que quieres obtener el texto completo de la fila o algún atributo específico
                let cellTexts = e.script("_.querySelectorAll('.rt-td').textContent");
                return cellTexts;
            }
        }
        return null;
    } else {
        return null;
    }
}


function convertListElementsToJson(cellElements) {
    var cellTexts = [];
    karate.forEach(cellElements, function (cell, index) {
        cellTexts.push({ index: index, text: cell.getText() });
    });
    return cellTexts;
}

/*
function convertListElementsToJson(cellElements) {
    var cellTexts = [];
    karate.forEach(cellElements, function (cell, index) {
        cellTexts.push({ index: index, text: cell.getText() });
    });
    return cellTexts;
}


* def jsonOfCellValues = eval 
    """
    karate.forEach(
      cellTexts, (cell, index) =>  {
          //console.log( "EL TEXTO --> ",cell.getText());
          //console.log( "EL INDEX --> ", index )
          let json = {
              text: cell.getText(),
              index: index
            };
            //console.log("EL JSON --> ", JSON.stringify(json));
            return json;
      }
    ); 
    """

*/