Lesson 16i: Dashboard / HighChart Cleanup & Gotchas
---------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1-hxVfrI_dxoOxBu9G9Px9ZErXsRp40PIw7Q7lbycRZs/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16i/dashboard/cleanup
<br>
<br>
<br>

<h3> HighCharts Gotchas </h3>

1. It's a good idea to manually call chart.destroy() on all charts in the ngOnDestroy() method

   ```
     public ngOnDestroy(): void {
       // Destroy all charts
       Highcharts.charts.forEach(function (chart: Chart | undefined) {
             if (chart) {
               chart.destroy();
             }
       });
     }
   ```
   <br>
   
1. Give each chart div a UNIQUE ID ACROSS ALL PAGES in your angular app
   Do NOT use the same div id for charts in multiple angular page
   ```
   This is bad:
      In chart1.component.html, you have  <div id="chart1" style="width: 100%; height: 100%;">
      In chart2.component.html, you have  <div id="chart1" style="width: 100%; height: 100%;">
       ---> Then your charts may not render when leaving chart1 to go to chart2.
   
   This is good:  (the div ids are different)
      In chart1.component.html, you have  <div id="chart1" style="width: 100%; height: 100%;">
      In chart2.component.html, you have  <div id="chart2" style="width: 100%; height: 100%;">
   ```


<br>
<br>

```
Procedure
---------
    1. Destroy all charts in the Dashboard page (when a user leaves this page)
        a. Edit dashboard.component.ts

        b. Make sure the class implements onDestroy
              export class DashboardComponent implements OnInit, OnDestroy, AfterViewInit {

        c. Make sure you have an ngOnDestroy() method
              public ngOnDestroy(): void {
        
              }

        d. Add this loop to the ngOnDestroy() method
        
              // Destroy all charts
              Highcharts.charts.forEach(function (chart: Chart | undefined) {
                  if (chart) {
                    console.log('dashboard page destroyed a chart');
                    chart.destroy();
                }
              });



    2. Destroy all charts in the usa-map page (when a user leaves this page)
        a. Edit usa-map.component.ts

        b. Make sure the class implements onDestroy
              export class UsaMapComponent implements OnInit, OnDestroy, AfterViewInit {

        c. Make sure you have an ngOnDestroy() method
              public ngOnDestroy(): void {
            
              }

        d. Add this loop to the ngOnDestroy() method
        
            // Destroy all charts
            Highcharts.charts.forEach(function (chart: Chart | undefined) {
                if (chart) {
                console.log('usa-map page destroyed a chart');
                    chart.destroy();
                }
            });


    3. Verify it works
        a. Activate the Debugger on "Full WebApp"
        b. Open your browser and press F12 to see your browser console
        c. Go to your "USA Map" page
        d. Leave the "USA Map" page
           -- You should see 'usa-map page destroyed a chart'

        e. Go to your "Dashboard" page
        f. Leave your "Dashboard" page
           -- You should see 'dashboard page destroyed a chart' multiple times  (once for each chart)
 

```
