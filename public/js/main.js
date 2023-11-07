async function loadJson() {


  const response = await fetch('http://127.0.0.1:3000/get_json?');
  const data = await response.json();
  console.log(data);
  console.log(typeof jsonData)
  return data;

}

var jsonData = loadJson();
