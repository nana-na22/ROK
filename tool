<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Kingdom 3522</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
<style>
  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f0f2f5;
    margin: 0;
    padding: 20px;
    color: #333;
  }
  .container {
    max-width: 800px;
    margin: 0 auto;
    background: #fff;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  h2, h3 {
    color: #2c3e50;
    margin-bottom: 20px;
  }
  input[type="text"] {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    border: 1px solid #ddd;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 16px;
  }
  button {
    padding: 12px 24px;
    background-color: #3498db;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    transition: background-color 0.3s;
  }
  button:hover {
    background-color: #2980b9;
  }
  .result, .description, .point-info {
    margin-top: 20px;
    padding: 15px;
    background-color: #ecf0f1;
    border-radius: 4px;
    color: #34495e;
  }
  .category {
    font-weight: bold;
    color: #2c3e50;
    margin-top: 10px;
  }
  #chartContainer {
    margin-top: 30px;
    height: 300px;
  }
  .point-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
  }
  .point-table th, .point-table td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
  }
  .point-table th {
    background-color: #f2f2f2;
  }
</style>
</head>
<body>

<div class="container">
  <h2>Kingdom 3522</h2>
  <input type="text" id="powerInput" placeholder="Enter Power" onkeyup="formatNumber(this)">
  <button onclick="calculateRequirement()">Calculate DKP</button>
  
  <div id="result" class="result" style="display:none;"></div>
  <div class="category" style="display:none;"></div>
  <div class="description" style="display:none;"></div>

  <div id="chartContainer">
    <canvas id="resultChart"></canvas>
  </div>

  <div class="point-info" style="display:none;">
    <h3>Point Information</h3>
    <table class="point-table">
      <tr>
        <th>Action</th>
        <th>Points</th>
      </tr>
      <tr>
        <td>T4 Kill</td>
        <td>1 Point</td>
      </tr>
      <tr>
        <td>T5 Kill</td>
        <td>2 Points</td>
      </tr>
      <tr>
        <td>Dead</td>
        <td>10 Points</td>
      </tr>
    </table>
  </div>
</div>

<script>
let chart;

function formatNumber(input) {
  let value = input.value.replace(/\D/g, '');
  input.value = new Intl.NumberFormat('en-US').format(value).replace(/,/g, '.');
}

function calculateRequirement() {
  var powerStr = document.getElementById('powerInput').value;
  var power = parseFloat(powerStr.replace(/\./g, ''));
  if (!power) {
    alert('Please enter a valid value for Power.');
    return;
  }

  // Updated formula:
  // If Power < 50,000,000:
  //   DKP = 20% (0.2)
  //   Dead Requirement = 2% (0.02)
  // If Power >= 50,000,000:
  //   DKP = 30% (0.3)
  //   Dead Requirement = 3% (0.03)

  let dkpGoal, deadRequirement, category;

  if (power >= 50000000) {
    dkpGoal = power * 0.3;
    deadRequirement = power * 0.03;
    category = '30% DKP and 3% Dead Requirement category';
  } else {
    dkpGoal = power * 0.2;
    deadRequirement = power * 0.02;
    category = '20% DKP and 2% Dead Requirement category';
  }

  var dkpGoalFormatted = new Intl.NumberFormat('en-US').format(dkpGoal).replace(/,/g, '.');
  var deadRequirementFormatted = new Intl.NumberFormat('en-US').format(deadRequirement).replace(/,/g, '.');

  document.getElementById('result').style.display = 'block';
  document.getElementById('result').innerHTML = 'DKP Goal: ' + dkpGoalFormatted + '<br>Dead Requirement: ' + deadRequirementFormatted;
  document.querySelector('.category').style.display = 'block';
  document.querySelector('.category').textContent = 'You fall into the ' + category + ' based on your Power.';
  document.querySelector('.description').style.display = 'block';
  document.querySelector('.description').innerHTML = `
    <p><strong>DKP Goal:</strong> ${dkpGoalFormatted}</p>
    <p><strong>Dead Requirement:</strong> ${deadRequirementFormatted}</p>
  `;

  updateChart(dkpGoal, deadRequirement);
  document.querySelector('.point-info').style.display = 'block';
}

function updateChart(dkpGoal, deadRequirement) {
  const ctx = document.getElementById('resultChart').getContext('2d');
  
  if (chart) {
    chart.destroy();
  }
  
  chart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['DKP Goal', 'Dead Requirement'],
      datasets: [{
        label: 'Points',
        data: [dkpGoal, deadRequirement],
        backgroundColor: [
          'rgba(54, 162, 235, 0.6)',
          'rgba(255, 99, 132, 0.6)'
        ],
        borderColor: [
          'rgba(54, 162, 235, 1)',
          'rgba(255, 99, 132, 1)'
        ],
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      scales: {
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: 'Points'
          }
        }
      },
      plugins: {
        tooltip: {
          callbacks: {
            label: function(context) {
              let label = context.dataset.label || '';
              if (label) {
                label += ': ';
              }
              if (context.parsed.y !== null) {
                label += new Intl.NumberFormat('en-US').format(context.parsed.y.toFixed(0)).replace(/,/g, '.') + ' Points';
              }
              return label;
            }
          }
        }
      }
    }
  });
}
</script>
</body>
</html>
