Lesson 16k: Dashboard / Setup a Chart on the Welcome Page
---------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1tE4W98ozp8WXI4hBKrirDIfh3d6pHNNZ7EUv3YG6oIw/edit?usp=sharing
      

<br>
<br>

<h3> Problem Set </h3>

Problem:  Highcharts blows-up if my chart is on the welcome page with a HighChart Error 13 (because HighCharts is trying to render a chart to a div but the div does not exist)<br>
Solution:  Have the welcome page wait until the div exists and then render the charts<br>



<br>
<br>

```
Procedure
---------
    1. Edit welcome.component.html 
        a. Add a chart div to the html
           NOTE:  We need an html template variable on it

         	<!-- Chart 1 -->
          	<div id="chart1" style="width: 100%; height: 100%"  #chart1></div>

         	<!-- Chart 2 -->
          	<div id="chart2" style="width: 100%; height: 100%"  #chart2></div>

         	<!-- Chart 3 -->
          	<div id="chart3" style="width: 100%; height: 100%"  #chart3></div>



    2. Edit welcome.component.ts
        a. Added the ViewChild to it:

            @ViewChild('chart1') chart1Div: ElementRef;
            @ViewChild('chart2') chart2Div: ElementRef;
            @ViewChild('chart3') chart3Div: ElementRef;


        b. Change the reloadData() method
        
            // Run this code in setInterval() so the code is executed after angular does a refresh
            // NOTE:  The 1 ms number doesn't matter as it will only run once
            let intervalFunction = setInterval(() => {
        
            if (this.chart1Div != undefined && this.chart2Div != undefined && this.chart3Div != undefined) {
                // All 3 chart divs exist.  So, render the charts now.
                    Highcharts.chart('chart1', this.chartOptions1);
                    Highcharts.chart('chart2', this.chartOptions2);
                    Highcharts.chart('chart3', this.chartOptions3);
        
                    // Redraw all charts on this page (so they fit perfectly within the mat-card tags
                    Highcharts.charts.forEach(function (chart: Chart | undefined) {
                        chart?.reflow();
                    });
        
                    this.dataIsLoading = false;
        
                    clearInterval(intervalFunction);
                   }
            }, 1);


        NOTE:  The code works when using setInterval but I am not sure why

        This if statement must be inside the setInterval (otherwise it will not work).

        So, I am certain that the if statement is really needed here.





```
