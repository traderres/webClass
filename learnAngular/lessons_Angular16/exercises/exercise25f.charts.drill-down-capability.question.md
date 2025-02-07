```
Exercise 25f / Create a Column Chart w/Drill Down
-------------------------------------------------
Problem:  As users click-in one parent chart, I want Highcharts to render a new "drill down" child chart


```
![](../images/exercise25f_image1.png)
```
Clicking on a column or hyperlink opens a drill down column chart [see below]
```
![](../images/exercise25f_image2.png)
```


Part 1 / Create the small column chart component
------------------------------------------------
 1. Create the small column chart component:   ColumnChartSmallComponent
 
 
 2. Edit the Main Dashboard Page / HTML
    a. Remove the hard-coded "Chart 3"
    b. Add-in the component to your dashboard chart
    c. Make sure your this chart uses 100% of the height and width (of the parent div)
    d. Verify that you see "column-chart-small-component works!" in your dashboard
        
        
 
 3. Edit the little column chart component / HTML
    NOTE:  The entire HTML is just a div with a unique ID -- e.g., "chart3"
           The div should use 100% of the height and width
               
        
        
 4. Edit the little column chart component / TypeScript

 
 
 5. Add the imports for high charts (before the @Component)
 
        import * as Highcharts from "highcharts";
        window.Highcharts = Highcharts;
        
        // Turn on the high-chart context menu view/print/download options
        import HC_exporting from "highcharts/modules/exporting";
        HC_exporting(Highcharts);
        
        // Turn on the high-chart context menu *export* options
        // NOTE:  This provides these menu options: Download CSV, Download XLS, View Data Table
        import HC_exportData from "highcharts/modules/export-data";
        HC_exportData(Highcharts);
        
        // Do client-side exporting (so that the exporting does *NOT* go to https://export.highcharts.com/
        // NOTE:  This does not work on all web browsers
        import HC_offlineExport from "highcharts/modules/offline-exporting";
        HC_offlineExport(Highcharts);
        
        // Turn on the drill-down capabilities
        import {Chart} from "highcharts";
        import HC_drillDown from "highcharts/modules/drilldown";
        HC_drillDown(Highcharts);
               
    
 6. Add a private class variable called chartOptions
        
  
 7. Set the chartOptions to hold the chart options for a line chart
    a. Go to https://www.highcharts.com/demo/highcharts/column-drilldown
       *OR*
       Go to https://www.highcharts.com/
       Click on Demos
       Select "Column and bar charts" -> Column with drilldown
       
    b. Press JSfiddle button
    c. Copy the chart configuration from the javaScript
    d. Set your chartOptions variable equal to it
           
           
 
 8. Edit the chartOptions object:  
    -- Remove the series    from the object
    -- Remove the drilldown from the object
    HINT:  Collapse the series section in IntelliJ and then delete that line

   

 9. Create a private method:  reloadData()
    a. This method set the series section of your chartOptions object
         
    b. This method will tell Highcharts to render the chart in the div called "chart3"
               
          
          
          
10. After the component has rendered the HTML, call your reloadData() method


11. Verify that you see the chart in the dashboard page





Part 2 / Create the full-size version of this column chart component
--------------------------------------------------------------------
 1. Setup the Page
    a. Generate the component:                ColumnChartLargeComponent
    b. Add the route to constants.ts:         the route will be this:   page/dashboard/column-chart-drill-down
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Use the debugger to verify that the navbar link works
    
    
    NOTE:  Do *NOT* add it to the navigation bar


 2. Setup this page layout
     +-------------------------------------------------------------------+
     | Column Chart w/Drill Down                                    Help |
     +-------------------------------------------------------------------+
     |                                                                   |
     |                                                                   |
     +-------------------------------------------------------------------+





 3. Change the bottom of the page so use the VISIBLE height of the browser
     +-------------------------------------------------------------------+
     | Column Chart w/Drill Down                                    Help |
     +-------------------------------------------------------------------+
     | Chart is here                                                     |   Height of the bottom of page *STRETCHES*
     |                                                                   |
     +-------------------------------------------------------------------+
 
        
        
        
 4. Put your little chart in the big page



 
 5. Edit the Dashboard Page / TypeScript
    a. Inject the router
    
    b. Add a method:  navigateToColumnChartPage()
       -- This method should take the user to the large column chart page
 
     
    
 6. Edit the Dashboard Page / HTML
    a. Add a click handler to the div around small column chart so it calls your new method
 
    b. Change the cursor to a pointer if the mouse is over your new chart  (as it is clickable)
     
        <div class="w-[400px] h-[200px] mat-elevation-z4 p-2.5 cursor-pointer" (click)="this.navigateToColumnChartPage()">
            <!-- C H A R T     3  -->
            <app-column-chart-small class="h-full w-full"></app-column-chart-small>
        </div>
           
           
           
 7. Try it out
    a. Go to the Dashboard Page
    b. Click on the drill down chart
       -- It should take you to the full size page




 8. Correct the problem with the hamburger
    Problem:  Clicking on the hamburger in the large column chart page causes scrollbars to appear
    

```
