
fetch('http://127.0.0.1:3000/get_json?')
  .then(response => response.json())
  .then(json => console.log(json))
