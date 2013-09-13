drawChartDataDonut = (e) ->
  data = google.visualization.arrayToDataTable([["Task", "Requests"], ["Valid", e.detail.ValidRequests], ["Invalid", e.detail.InvalidRequests], ["Pending", e.detail.IssuedRequests]])
  options =
    title: "Request types"
    pieHole: 0.4
  chart = new google.visualization.PieChart(document.getElementById("donutChart"))
  chart.draw data, options
drawChartDataRequestHistory = (e) ->
  data = google.visualization.arrayToDataTable(eval_(e.detail))
  console.log data
  options = title: "Requests"
  chart = new google.visualization.LineChart(document.getElementById("requestHistoryChart"))
  chart.draw data, options
drawChartDataUsersHistory = (e) ->
  data = google.visualization.arrayToDataTable(eval_(e.detail))
  console.log data
  options = title: "Users"
  chart = new google.visualization.LineChart(document.getElementById("usersHistoryChart"))
  chart.draw data, options
google.load "visualization", "1",
  packages: ["corechart"]

window.addEventListener "drawChartDataDonut", drawChartDataDonut, false
window.addEventListener "drawChartDataRequestHistory", drawChartDataRequestHistory, false
window.addEventListener "drawChartDataUsersHistory", drawChartDataUsersHistory, false