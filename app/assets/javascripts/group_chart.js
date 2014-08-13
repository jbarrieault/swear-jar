$(function(){

    Chart.defaults.global.responsive = true;
    // Chart.defaults.global.scaleIntegersOnly = true
    // Chart.defaults.global.scaleBeginAtZero = true

    var ctx = []
     ctx.push(document.getElementById("line-chart").getContext("2d"));
     ctx.push(document.getElementById("pie-chart").getContext("2d"));
     ctx.push(document.getElementById("bar-chart").getContext("2d"));


    var triggerLabels  = gon.trigger_labels;
    var triggerData = gon.trigger_data;
    var violationLabels = gon.violation_labels;
    var violationData = gon.violation_data;
    var userLabels = gon.user_labels
    var userData = gon.user_data
    var colors = ["rgba(127, 140, 141, 1)", "rgba(52, 73, 94, 1)", "rgba(59, 145, 47, 1)","rgba(53, 57, 60, 1)", "rgba(141, 170, 198, 1)", "rgba(237, 238, 239, 1)", "rgba(117, 190, 111, 1)"
    ]
    var highlightColors = ["rgba(127, 140, 141, .6)", "rgba(52, 73, 94, .6)", "rgba(59, 145, 47, .6)","rgba(53, 57, 60, .6)", "rgba(141, 170, 198, .6)", "rgba(237, 238, 239, .6)", "rgba(117, 190, 111, .6)"]

    var dailyViolationData = {
        labels: violationLabels,
        datasets: [
            {
                label: "Violations over time",
                fillColor: "rgba(141,170,198, .5)",
                strokeColor: "rgba(52,73,94,.8)",
                pointColor: "rgba(52,73,94,.8)",
                pointStrokeColor: "rgba(52,73,94,.8)",
                pointHighlightFill: "rgba(52,73,94,.1)",
                pointHighlightStroke: "rgba(52,73,94,1)",
                data: violationData
            } 
        ]
    };

    var triggerUsageData = []


    for(var i = 0; i< triggerData.length; i++){
      triggerUsageData.push(
          {
            value: triggerData[i],
            color: colors[i],
            highlight: highlightColors[i],
            label: triggerLabels[i]
        });
    }
 
    var userViolationData = {
        labels: userLabels,
        datasets: [
            {
                label: "Violations per User",
                fillColor: "rgba(138,51,36,1)",
                strokeColor: "rgba(138,51,36,1)",
                highlightFill: "rgba(138,51,36,.6)",
                highlightStroke: "rgba(138,51,36,1)",
                data: userData
            }
        ]
    };

    var userViolationOptions = {scaleBeginAtZero : true}


    var dailyViolations = new Chart(ctx[0]).Line(dailyViolationData, {bezierCurve : false,pointDotRadius : 2});

    var triggerUsage = new Chart(ctx[1]).Pie(triggerUsageData);
    var userViolations = new Chart(ctx[2]).Bar(userViolationData);


})
