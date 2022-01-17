Lesson 16c:  Dashboard / Add Chart / Column Chart
-------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1VX3JS7mNxLod0JJSszHM2fGPPYHzjICwiOUmF6Egnjw/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16c/dashboard/add-column-chart
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  I want to insert a column chart into the chart 2 spot<br>
Solution:  Use HighCharts and add a <b>column chart</b><br>
<br>

![](https://lh3.googleusercontent.com/pXQquu3FdNgvBpNTegw3jDAFrDfnLyoxu4RAbkRoWM7p-vddwk7-DeRagMiF42pxqKXF1Q6dwThEFR3PgvIvgvnD_tFny8kX9NyDLIL1UUXuljoHV3vvHcEXtv9dUcCNon6bBEDW)




<br>
<br>

```

Procedure
---------
    1. Set the div with an id="chart2" in the 2nd mat-grid-tile
        a. Edit dashboard.component.html

        b. Change this mat-card 
            
           From this:
                    <mat-card class="mat-elevation-z4" (dblclick)="this.toggleSize(2)">
                            <mat-card-content>
            
                                <!-- Chart 2 -->
                                Chart 2
            
                            </mat-card-content>
                    </mat-card>
            
            
           To this:
                    <mat-card class="mat-elevation-z4" (dblclick)="this.toggleSize(2)">
                            <mat-card-content class="chart-content">
            
                                <!-- Chart 2 -->
                                <div id="chart2" style="width: 100%; height: 100%;"></div>
            
                            </mat-card-content>
                    </mat-card>
            


    2. Add the chartOptions2 object to the class
        a. Edit dashboard.component.ts

        b. Add this private variable:  chartOptions2:
            
              // Chart 2 is a bar chart2
              private chartOptions2: any = {
                chart: {
                type: 'column'   // Use type:'bar' for horizontal chart.  Use type:'column' for vertical bar chart
                },
                credits: {
                enabled: false    	// Hide the highcharts.com label
                },
                title: {
                text: 'Case Timeliness of Closes Cases (Days)'
                },
                xAxis: {
                categories: ['0-30', '31-60', '61-90', '91-120', '121-150', '151-180', '181-210', '211-240', '241-270', '271-300', '301+']
                },
                yAxis: {
                min: 0,
                title: {
                    text: 'Number of Cases'
                }
                },
                legend: {
                reversed: false
                },
                plotOptions: {
                series: {
                    stacking: 'normal'
                }
                },
                series: []
              };


        c. Adjust the ngOnInit() to set hard-coded data and render the chart to the div with id="chart2"
            
           Add this to ngOnInit():
            
               // Update chart 2 with hard-coded data
               this.chartOptions2.series =  [
                {
                    name: 'T3',
                    legendIndex: 1,
                    data: [300, 5500, 1800, 1600, 1200, 1500, 1000, 800, 500, 400, 1000]
                },
                {
                    name: 'T3R',
                    legendIndex: 2,
                    data: [2, 2, 100, 2, 1]
                },
                {
                    name: 'T5',
                    legendIndex: 3,
                    data: [25, 500, 551, 600, 400, 300, 200, 500, 100, 100, 1200]
                },
                {
                    name: 'T5R',
                    legendIndex: 4,
                    data: [200, 190, 190, 100, 50, 12, 37, 42, 98, 50, 600]
                }
               ];




    3. Verify that the bar chart appears as chart 2
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboards"
        c. Verify you see 2 charts:
```
![](https://lh4.googleusercontent.com/HzmTPaYYUpke98-zd7CuBZXy1TVGmmQqXVaMpmhYjw0-DN7L0e94b5YeacAp5OI-xyUEK34EHMak60UM_TxlKOHCVOG8ax89A1UtJuTQFGeaBFQW0FT_AzogW2dU14eCXbrGeIwk)
```


        d. Double-click on chart2
           -- Verify it expands to 2x2

```
