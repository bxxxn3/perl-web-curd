
fetch('http://127.0.0.1:3000/get_json?')
  .then(response => response.json())
  .then(json => console.log(json))
//   .then(jsonData => {
//     for (var key in jsonData) {
//       if (jsonData.hasOwnProperty(key)) {
//         var rowData = jsonData[key];
//         var row = document.createElement("tr");
//         var idCell = document.createElement("td");
//         var nameCell = document.createElement("td");
//         var ageCell = document.createElement("td");
//         idCell.textContent = rowData.id || "";
//         nameCell.textContent = rowData.name || "";
//         ageCell.textContent = rowData.age || "";
//         row.appendChild(idCell);
//         row.appendChild(nameCell);
//         row.appendChild(ageCell);
//         dataRows.appendChild(row)
//       }
//     }
//   }
// )
// .catch(error => console.error('Error fatching data:', error));