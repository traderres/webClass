Lesson 16j: Dashboard / Column Chart Drill Down
-----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1ohvytAeHFGe8LSAKdw3xyksDcCmzIiDcjLN80Uuih0Q/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16j/dashboard/chart-drilldown
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  How do you create a column chart with a <b>drill down capability</b>?<br>
Solution: Tell HighCharts that you have drill-down data and it will render it.<br>
<br>
<br>

![](https://lh6.googleusercontent.com/pF248KPAoQPhPXPsFHo4jIGUDIHj_U9Dg65GryzM7QinhVSOvWJRDJoPCKzqIdTdXk2atioKN2YxDGNYmj-SJzYiODH9x6yF42j488yRNuZ4VCX3jKXfo3lDMpuZqnltqGJLmpro)  
This is a drill down chart, so clicking one of the columns opens a new chart  
  
<br>
<br>
  
![](https://lh4.googleusercontent.com/TJLjBDy7YG_uknCWzQPZt0QVIBZrSI8BrFn__DNqCRTWIsmHRRhpqVWWh80ovuuVnDl255PRCOOzmrdUaeuWEmyLq584DyhBWOW8YkmSlqp3F6JGif2n-mccQNatyBP_ZACpgRbC)  
Click on "Back to Main Chart" to return to the original chart

  
<br>
<br>

<h3>Approach</h3>

1. Add a new chart called ChartDrillDown (add it to the analytics directory)

1. Add a route for it called "page/bar-drill-down"

1. Add a navigation icon for "page/bar-drill-down"  

1. Setup the page layout using Angular Flex
   1. Add the page-container css class
   1. Add Angular flex with 2 rows
      ![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/lesson16j_image1.png)

1. Fill-in the chart-drill-down.component.ts class

   1. Add import statements for Highcharts
   2. Turn on the highchart context menu options
   3. Add chartOptions1 map (with the options for the chart)
   4. Add reloadData()
   5. Add ngAfterViewInit() and have it call reloadData
   6. Add ngOnDestroy and have it destroy all charts
   7. Add ngOnInit() and have it set options for all charts on the page:  
        

<br>
<br>

```

Procedure
---------
Procedure
    1. Add a new component called "ChartDrillDown"

    2. Add a route such that "page/chart-drill-down" takes users to the ChartDrillDown component

    3. Add a navigation icon called "Drill Down Chart" that takes users to "page/chart-drill-down"

    4. Verify that the navigation icon works

    5. Add the page-container CSS class
        a. Edit chart-drill-down.component.css
        b. Add the page-container CSS class
        c. Have it set the margin to be 10 pixels
           *OR*
           Add it to your styles.css (do it the smart way!)


    6. Fill-in the HTML of the page
        a. Edit chart-drill-down.component.html

        b. Setup a wrapper div that uses the page-container class

        c. Inside the wrapper div, setup Angular flex layout
            i. Add a column layout
                1. Inside the column layout, add a 1st row with a left and right side
                    a. Inside the left row add a page title using <h1 class="mat-h1">

                    b. Inside the right row, leave it empty (we can add buttons later)

                2. Inside the column layout, add a 2nd row

                    a. Inside the second row, add a mat-card
                        i. Inside the mat-card, add mat-card-content
                            1. Inside the mat-card-content,

                                 create a div with id="drillDownChart1" and
                                 have it use 100% of the width & height.



        d. Have the chart use the entire height of the page (-165 px) 
    
            <!-- Setup a wrapper div that uses the entire height (total height - 165px) -->
            <div style="height: calc(100vh - 165px);">
    
                    <!-- Drill Down Chart -->
                    <div id="drillDownChart1" style="width: 100%; height: 100%;"></div>
    
            </div>


        e. Give a 3D effect to the mat-card by setting the mat-elevation-z4 CSS class to it 



    7. Verify that the page shows your mat-card and it uses the entire page height
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Drill Down Chart"
        c. Verify that the mat-card uses the entire page  (look for the 3D effect)



    8. Fill in the TypeScript class
        a. Edit chart-drill-down.component.ts

        b. Make sure the class implements OnInit, OnDestroy, and AfterViewInit

        c. Add import statements for Highcharts
            
            import * as Highcharts from "highcharts";	
            window.Highcharts = Highcharts;


        d. Turn on the highchart context menu options
            
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


        e. Add chartOptions1 options to create a simple bar chart:
            
              private chartOptions1: any = {
                chart: {
                    type: 'column',
                    displayErrors: true
                },
                credits: {
                    enabled: false    	// Hide the highcharts.com label
                },
                title: {
                    text: 'Basic drilldown'
                },
                xAxis: {
                    type: 'category'
                },
                legend: {
                    enabled: false
                },
                plotOptions: {
                    series: {
                            borderWidth: 0,
                            dataLabels: {
                                enabled: true
                            }
                    }
                },
                exporting: {
                    buttons: {
                            contextButton: {
                                menuItems: [
                                        'viewFullscreen',
                                    'printChart',
                                    'separator',
                                        'downloadPNG',
                                        'downloadJPEG',
                                        'downloadPDF',
                                        'downloadSVG',
                                        'separator',
                                        'downloadCSV',
                                        'downloadXLS'
                                    ]
                            }
                    }
                }
              };


        f. Add the dataIsLoading variable  
              public dataIsLoading: boolean = false;



        g. Add this method:  reloadData()
            
             public reloadData(): void {
                this.dataIsLoading = true;
            
                // Load Chart Data
                this.chartOptions1.series = [{
                name: 'Main Chart',  	// Named used for the "Back to <>" when drilled-in
                colorByPoint: true,
                data: [{
                    name: 'Animals',
                    y: 5,
                    drilldown: 'animals'
                }, {
                    name: 'Fruits',
                    y: 2,
                    drilldown: 'fruits'
                }, {
                    name: 'Cars',
                    y: 4,
                    drilldown: 'cars'
                }]
                }];
            
                // Load Drill down Chart Info
                this.chartOptions1.drilldown = {
                series: [{
                    id: 'animals',
                    data: [
                    ['Cats', 4],
                    ['Dogs', 2],
                    ['Cows', 1],
                    ['Sheep', 2],
                    ['Pigs', 1]
                    ]
                }, {
                    id: 'fruits',
                    data: [
                    ['Apples', 4],
                    ['Oranges', 2]
                    ]
                }, {
                    id: 'cars',
                    data: [
                    ['Toyota', 4],
                    ['Opel', 2],
                    ['Volkswagen', 2]
                    ]
                }]
                };
            
                // Render the chart
                Highcharts.chart('drillDownChart1', this.chartOptions1);
            
                this.dataIsLoading = false;
              }


        h. Add ngAfterViewInit() and have it call reloadData


        i. Add ngOnDestroy and have it destroy all charts


        j. Add ngOnInit() and have it set options for all charts on the page:
            
                // Set options for all highchart menus on this page
                Highcharts.setOptions( {
                    lang: {
                            thousandsSep: ','	// Set the thousand separator as a comma
                    }
                });


    9. Verify that the drill down chart works
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Drill Down Chart"
```
![](https://lh6.googleusercontent.com/pF248KPAoQPhPXPsFHo4jIGUDIHj_U9Dg65GryzM7QinhVSOvWJRDJoPCKzqIdTdXk2atioKN2YxDGNYmj-SJzYiODH9x6yF42j488yRNuZ4VCX3jKXfo3lDMpuZqnltqGJLmpro)
```

        c. Single-click on one the charts
           -- And, the chart should change to a new chart
```
![](https://lh3.googleusercontent.com/amiyrFY66qDG2mrO3R5Iu-X1gNuT7nJHQS98VMsb-oJSFGIjZSlyttY1-zJzy5jAa2Xs7kwuOkW4VjJBHm6NkjgekEa5t_i_WdJC5ld3rJalCIcRAds0fgOaY5rYUl2hGskzkXFS)
