Lesson 16b:  Dashboard / Add Chart / Pie Chart
----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/17A3tFvqp2pB0DDE8-Vjb7YHufIKwhlg25mBgDbC8Ne4/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16b/dashboard/add-pie-chart
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  I want to insert a <b>pie chart</b> into one of the mat-cards<br>
Solution:  Use HighCharts<br>
<br>

![](https://lh5.googleusercontent.com/bUJumZn_TDknm0QWxYCzT8wp-WC8PbQ9Z1CEmIFU1cwJ1cx89uSRBT0imBfXf4jC10sTdvO1H0Oa_kUiMbIv7-SvSyzz1Vy2zdD9clkJCChRfM64hzCFhgjlN3jj0KeY8eJxl_r1)



<br>
<br>

```
Procedure
---------
    1. Add HighCharts to the project

        a. Install the highcharts NPM packages   (install version 9.1.0 or 9.2.2)
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> npm install highcharts@9.1.0
    
        b.Verify that highcharts is found in your frontend/package.json
          --  You should see something like this in your frontend/package.json
                "highcharts": "^9.1.0",
            
        c. Remove the carrots from package.json for highcharts so it does not get automatically upgraded:
                "highcharts": "9.1.0",


           NOTE:  highcharts 9.2.2 has fixes for the Gantt chart so it displays in dark mode


        d. Delete the frontend/node_modules and run "npm install" on the package.json
  
        e. In Intellij:  Right-click on your package.json -> Run npm Install

        f. Build the project (to make sure it still compiles successfully)
           unix> cd ~/intellijProjects/angularApp1
           unix> mvn clean package -Pprod




    2. Add the chart-content CSS class
        a. Edit dashboard.component.css

        b. Add this CSS class:

            .chart-content {
              height: 100%;    /* Needed to ensure the chart fills uses all of the height */
            }

        c. Edit the mat-card CSS class by adding

            mat-card {
              /* Set spacing between cards */
              position: absolute;
              top: 10px;
              left: 10px;
              right: 10px;
              bottom: 10px;
              overflow-y: auto;
            
              padding: 5px;	/* Reduce the padding so the chart uses-up more space in the card */
            }


 


    3. Adjust the dashboard.component.html so there is a <div> tag for chart1
        a. Edit dashboard.component.html

        b. Change this:

                <mat-grid-tile colspan="1" rowspan="1">
                    <mat-card class="mat-elevation-z4">
                        <mat-card-content>
                
                           <!-- Chart 1 -->
                           Chart 1
                
                        </mat-card-content>
                    </mat-card>
                 </mat-grid-tile>


            To this:

                <mat-grid-tile colspan="1" rowspan="1">
                    <mat-card class="mat-elevation-z4">
                        <mat-card-content class="chart-content">
                
                           <!-- Chart 1 -->
                                   <div id="chart1" style="width: 100%; height: 100%"></div>
                
                        </mat-card-content>
                       </mat-card>
                 </mat-grid-tile>


    4. Adjust the dashboard.component.ts so that it initializes the chart
        a. Edit dashboard.component.ts

        b. Add the highchart imports and settings to the top (before the @Component section)
            
            import * as Highcharts from "highcharts";	
            window.Highcharts = Highcharts;
            
            // Turn on the highchart context menu view/print/download options
            import HC_exporting from "highcharts/modules/exporting";
            HC_exporting(Highcharts);
            
            // Turn on the highchart context menu *export* options
            // NOTE:  This provides these menu options: Download CSV, Download XLS, View Data Table
            import HC_exportData from "highcharts/modules/export-data";
            HC_exportData(Highcharts);
            
            // Do client-side exporting (so that the exporting does *NOT* go to https://export.highcharts.com/
            // NOTE:  This does not work on all web browsers
            import HC_offlineExport from "highcharts/modules/offline-exporting";
            HC_offlineExport(Highcharts);
            
            // Turn on the drill-down capabilities
            import HC_drillDown from "highcharts/modules/drilldown";
            import {Chart} from "highcharts";
            HC_drillDown(Highcharts);


        c. Make sure your dashboard component implements OnInit, OnDestroy, and AfterViewInit

        d. Add this call to the ngOnInit() to set Highchart options:
                
                public ngOnInit(): void {
                
                     // Set options for all highchart menus on this page
                     Highcharts.setOptions( {
                         lang: {
                           thousandsSep: ','	// Set the thousand separator as a comma
                         }
                     });
                     ...
                    
                    }


        e. Add this variable:
             public dataIsLoading: boolean = false;


        f. Add this private method:  reloadData
            
              private reloadData(): void {
                this.dataIsLoading = true;
            
                // Update chart 1 with hard-coded data
                this.chartOptions1.series[0].data = [
                {
                    name: "Item 3",
                    y: 989
                },
                {
                    name: "Item 3R",
                    y: 249
                },
                {
                    name: "Item 5",
                    y: 1035
                },
                {
                    name: "Item 5R",
                    y: 324
                }
                ];
            
                // This renders the chart 
                // NOTE:  You cannot render a chart from ngOnInit().  You can from ngAfterViewInit().
                Highcharts.chart('chart1', this.chartOptions1);
            
            
                // Redraw all of the charts on this page (so they fit perfectly within the mat-card tags
                Highcharts.charts.forEach(function (chart: Chart | undefined) {
                chart?.reflow();
                });
            
                this.dataIsLoading = false;
              }


        g. Add this map with all of the chart settings:
            
            private chartOptions1: any = {
                credits: {
                  enabled: false    	// Hide the highcharts.com label
                },
                caption: {
                  text: ''
                },
                chart: {
                  type: 'pie'
                },
                title: {
                  text: 'Pending Case Distribution'
                },
                subtitle: {
                  text: ''
                },
                accessibility: {
                  announceNewData: {
                 enabled: true
                  },
                  point: {
                 valueSuffix: '%'
                  }
                },
                plotOptions: {
                  series: {
                 dataLabels: {
                   enabled: true,
                   format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>value: {point.y}'
                 }
                  }
                },
                tooltip: {
                  headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
                  pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y}</b> or <b>{point.percentage:.1f}%</b> of total<br/>'
                },
                series: [
                  {
                 name: "Browsers",
                 colorByPoint: true,
                 data: []
                  }
                ]
              };


        h. Add the ngAfterViewInit method (so it reloads data)

              public ngAfterViewInit(): void {
                // Reload chart data
                // NOTE:  This call must be in ngAfterViewInit() and not in ngOnInit()
                this.reloadData();
              }
            


    5. Increase the size of the tiles so they are 350px tall
        a. Edit dashboard.component.html

        b. Change the <mat-grid-list> tag so it has rowHeight="350px"

            <!-- Setup the 1st row of graphs.  Each graph is 350px tall -->
            <mat-grid-list [cols]="this.totalColumns" rowHeight="350px">


    6. Verify that you see a pie chart in Chart1
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboard"
```
![](https://lh4.googleusercontent.com/VftXSRIHGhrVHo7wsfP33PHgE9xy3ZJoZ6YRjsJ3GvNXFWRJ6m4YDAk_7KW4VeXgzIsY9VnJ2A-__tJQsx7v2JFKDKLFL-Vs6bOq8IefC1zCATgLyFTZTtqsvkpLsjW6b3GilKu5)
```


        c. Now, resize the browser
           -- Verify that the chart grows (as the tile grows in width)


        d. Manually change the tile of chart1 so it has rowspan="2" and colspan="2"

        e. You should see the chart appear (as 2x2):
```
![](https://lh5.googleusercontent.com/86usxsGAR-yxIIUx3loSUmc5BXb9XQYtaMSDwMbbWOlNAO8-ioufAdOFOBLxa_Zf-o1t4QrQFSLA9j_BhEtx0jr9l06Ve_NmnWtzKwzfC06B5EfQwtQQ6sNRa4qOeEA8fiFWrSQt)
```


    7. Add a TileSizeDTO object 
        a. Create a TileSizeDTO object
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate class models/TileSizeDTO --skipTests

        b. Add the 3 public fields to the TileSizeDTO object
            
              public chartNumber: number;
              public rowSpan: number;
              public colSpan: number




    8. Add a double-click event cause the chart1 tile to toggle between 1x1 and 2x2
        a. Edit dashboard.component.ts

        b. Add a public array of TileSizeDTO objects that has an initial value of 1x1 for all:
            
              public tileSizes: TileSizeDTO[] = [
                {
                    chartNumber: 1,
                    rowSpan: 1,
                    colSpan: 1
                },
                {
                chartNumber: 2,
                rowSpan: 1,
                colSpan: 1
                },
                {
                chartNumber: 3,
                rowSpan: 1,
                colSpan: 1
                },
                {
                chartNumber: 4,
                rowSpan: 1,
                colSpan: 1
                },
                {
                chartNumber: 5,
                rowSpan: 1,
                colSpan: 1
                },
                {
                chartNumber: 6,
                rowSpan: 1,
                colSpan: 1,
                }];


        c. Add a private method:   resizeChartsToFitContainers()
           This method sends a 'resize' event
           Upon resize, HighCharts automatically resizes all charts on a page if you resize.  
           Thus, emitting a resize event causes HighCharts to make the charts fit into their parent containers

              /*
               * Send a 'resize' event 
               * This will cause HighCharts to resize all charts to fit inside their parent containers
               */
              private resizeChartsToFitContainers(): void {
                
                  setTimeout(()=> {
                // Send a 'resize' event
                // NOTE:  The window.dispatchEvent() call MUST be in a setTimeout or it will not work
                window.dispatchEvent(new Event('resize'));
                  }, 20);
                
              }
            
            

        d. Add a new public method:  toggleSize()
            
              public toggleSize(aChartNumber: number) {
            
                // Reset all other tiles to be 1x1
                this.tileSizes.forEach( (tile: TileSizeDTO) => {
                if (tile.chartNumber != aChartNumber) {
                    tile.rowSpan = 1;
                    tile.colSpan = 1;
                }
                })
            
                // Get the indexNumber in the array from the chartNumber
                let indexNumber: number = aChartNumber - 1;
            
                if (this.tileSizes[indexNumber].rowSpan == 1) {
                // This tile is already 1x1.  So, change it to 2x2
                this.tileSizes[indexNumber].rowSpan = 2;
                this.tileSizes[indexNumber].colSpan = 2;
                }
                else {
                // This tile is already 2x2.  So, change it to 1x1
                this.tileSizes[indexNumber].rowSpan = 1;
                this.tileSizes[indexNumber].colSpan = 1;
                }
            
                // Resize the charts to fit their parent containers
                this.resizeChartsToFitContainers();
              }
            

    9. Add a double-click event handler to each card
        a. Edit dashboard.component.html

        b. Change the <mat-card> for chart1 from this:
            
           From this:
                <mat-card class="mat-elevation-z4">
            
           To this:
               <mat-card class="mat-elevation-z4" (dblclick)="this.toggleSize(1)">


        c. REPEAT:  Add the (dblclick) event handler for the charts2 through chart6



        d. Adjust the <mag-grid-tile> so that the colspan and rowspan are pulled from the tileSizes array
            
           Change this:
                <mat-grid-tile colspan="1" rowspan="1">
            
           To this:    (for chart1 uses tileSizes[0]
               <mat-grid-tile [colspan]="tileSizes[0].colSpan" [rowspan]="tileSizes[0].rowSpan">   
               
                
                For chart1, use tileSizes[0]
                For chart2, use tileSizes[1]
                For chart3, use tileSizes[2]
                For chart4, use tileSizes[3]
                For chart5, use tileSizes[4]
                For chart6, use tileSizes[5]


    10. Verify that the double-click on each charts toggles from 1x1 to 2x2
        a. Activate the debugger on "Full WebApp"
        b. Click on "Dashboard"
           You should see this on page load:
```
![](https://lh3.googleusercontent.com/rFw36UU3n98WlmC6RD6NhgwnK38laYYmytXg_YhNm7OQ5SpVSTG4I0D2Lw-NnK3-71LbKkQdLtHzyJguoqZJtIKx2OtbnjNXkDZDbgyCWKIMFd02eRjugBDXpRVssmohEFkL6PKn)
```



        c. Double-click on chart1 and you should see this:
```
![](https://lh4.googleusercontent.com/9m53spRUAIjwfAAcJTn5IvCLC-afvinvFPd2u4SHkCFAE6yicPU89QHyhDxnbpCss_OXhwodkpRYdpZxdNNnB2DQFmuVYiAOwsPcwXXS7R29n71I7WihiG2d8uPkeR586Sag1j0e)
