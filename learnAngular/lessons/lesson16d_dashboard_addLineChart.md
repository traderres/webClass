Lesson 16d:  Dashboard / Add Chart / Line Chart
-----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1RQSzhJpcs75qeMbiRmPAqQnISrYyd-ux5BGnEzlHGcM/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16d/dashboard/add-line-chart
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  I want to insert a line chart into the chart 3 spot<br>
Solution:  Use HighCharts and make a column chart<br>
<br>

![](https://lh4.googleusercontent.com/A9HDqCwrbhLJZx8-u6GFw7mgbZmbCezB-7l1nQRnmVYqNAt4sZxMJBfpSOXJFUAkD5vZy5weaF8tRQQ1mqLJw520jKkovk9gW-sCcT3N2GGdwxfNcIssO3ZM6hRIB2VbL5s5KPWJ)



<br>
<br>

```
Procedure
---------
    1. Set the div with an id="chart3" in the 3rd mat-grid-tile
        a. Edit dashboard.component.html

        b. Change this mat-card 
            
           From this:
                    <mat-card class="mat-elevation-z4" (dblclick)="this.toggleSize(3)">
                            <mat-card-content>
            
                                <!-- Chart 3 -->
                                Chart 3
            
                            </mat-card-content>
                    </mat-card>
            
            
           To this:
                    <mat-card class="mat-elevation-z4" (dblclick)="this.toggleSize(3)">
                            <mat-card-content class="chart-content">
            
                                <!-- Chart 3 -->
                                <div id="chart3" style="width: 100%; height: 100%;"></div>
            
                            </mat-card-content>
                    </mat-card>



    2. Add the chartOptions2 object to the class
        a. Edit dashboard.component.ts

        b. Add this private variable:  chartOptions3
            
            // Chart 3 is a line chart
            private chartOptions3: any = {
                credits: {
                enabled: false    	// Hide the highcharts.com label
                },
                title: {
                text: 'Case Timeliness (Closed Investigations)'
                },
                subtitle: {
                text: ''
                },
                yAxis: {
                title: {
                    text: 'Avg Case Timeliness (Days)'
                }
                },
                xAxis: {
                type: 'datetime',
                tickInterval: 30 * 24 * 3600 * 1000,
                labels: {
                    rotation: 45,
                    step: 1,
                    style: {
                    fontSize: '13px',
                    fontFamily: 'Arial,sans-serif'
                    }
                },
                dateTimeLabelFormats: { 
                    month: '%b \'%y',
                    year: '%Y'
                },
                accessibility: {
                    rangeDescription: 'Range: The last 12 months'
                }
                },
                legend: {
                align: 'center',
                verticalAlign: 'bottom'
                },
                plotOptions: {
                series: {
                    label: {
                    connectorAllowed: false
                    }
                }
                },
                series: []
              }



        c. Adjust the ngOnInit() to set hard-coded data and render the chart to the div with id="chart3"
            
            Add this to ngOnInit():
            
                // Update chart 3 with hard-coded data
                this.chartOptions3.series = [{
                name: 'T3',
                data: [
                    [Date.UTC(2019, 6, 1), 110],
                    [Date.UTC(2019, 7, 1), 145],
                    [Date.UTC(2019, 8, 1), 135],
                    [Date.UTC(2019, 9, 1), 140],
                    [Date.UTC(2019, 10, 1), 100],
                    [Date.UTC(2019, 11, 1), 110],
                    [Date.UTC(2019, 12, 1), 100],
                    [Date.UTC(2020, 1, 1), 85],
                    [Date.UTC(2020, 2, 1), 70],
                    [Date.UTC(2020, 3, 1), 65],
                    [Date.UTC(2020, 4, 1), 60],
                    [Date.UTC(2020, 5, 1), 60]
            
                ]
                }, {
                name: 'T3R',
                data: [
                    [Date.UTC(2019, 6, 1), 175],
                    [Date.UTC(2019, 7, 1), 155],
                    [Date.UTC(2019, 8, 1), 100],
                    [Date.UTC(2019, 9, 1), 115],
                    [Date.UTC(2019, 10, 1), 87],
                    [Date.UTC(2019, 11, 1), 90],
                    [Date.UTC(2019, 12, 1), 88],
                    [Date.UTC(2020, 1, 1), 85],
                    [Date.UTC(2020, 2, 1), 86],
                    [Date.UTC(2020, 3, 1), 75],
                    [Date.UTC(2020, 4, 1), 60],
                    [Date.UTC(2020, 5, 1), 45]
                ]
                }, {
                name: 'T5',
                data: [
                    [Date.UTC(2019, 6, 1), 230],
                    [Date.UTC(2019, 7, 1), 225],
                    [Date.UTC(2019, 8, 1), 205],
                    [Date.UTC(2019, 9, 1), 210],
                    [Date.UTC(2019, 10, 1), 212],
                    [Date.UTC(2019, 11, 1), 185],
                    [Date.UTC(2019, 12, 1), 187],
                    [Date.UTC(2020, 1, 1), 150],
                    [Date.UTC(2020, 2, 1), 105],
                    [Date.UTC(2020, 3, 1), 85],
                    [Date.UTC(2020, 4, 1), 85],
                    [Date.UTC(2020, 5, 1), 70]
                ]
                }, {
                name: 'T5R',
                data: [
                    [Date.UTC(2019, 6, 1), 240],
                    [Date.UTC(2019, 7, 1), 238],
                    [Date.UTC(2019, 8, 1), 205],
                    [Date.UTC(2019, 9, 1), 200],
                    [Date.UTC(2019, 10, 1), 160],
                    [Date.UTC(2019, 11, 1), 155],
                    [Date.UTC(2019, 12, 1), 148],
                    [Date.UTC(2020, 1, 1), 140],
                    [Date.UTC(2020, 2, 1), 120],
                    [Date.UTC(2020, 3, 1), 85],
                    [Date.UTC(2020, 4, 1), 75],
                    [Date.UTC(2020, 5, 1), 125]
                ]
                }];
                


    3. Verify that the bar chart appears as chart 3
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboards"
        c. Verify you see 3 charts:
```
![](https://lh4.googleusercontent.com/A9HDqCwrbhLJZx8-u6GFw7mgbZmbCezB-7l1nQRnmVYqNAt4sZxMJBfpSOXJFUAkD5vZy5weaF8tRQQ1mqLJw520jKkovk9gW-sCcT3N2GGdwxfNcIssO3ZM6hRIB2VbL5s5KPWJ)
```


        d. Double-click on chart3
           -- Verify it expands to 2x2


```
