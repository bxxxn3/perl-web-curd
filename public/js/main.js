async function loadJson() {
  const response = fetch('http://127.0.0.1:3000/get_json?')
    .then((data) => data.json()
      .catch(err => console.log('Error: ', err))
    );
  return response;
}



async function reloadTable() {
  $(document).ready(async function () {
    var list = await loadJson();
    console.log('afaffa');
    $('#firsttable').footable({
      rows: list
    });
  });
}

