```
Exercise 25j / Create a 3-Gauge Chart
-------------------------------------


```
![](../images/exercise25j_image1.png)
```



Part 1 / Update your ChartService to it has a method to return the guage data
-----------------------------------------------------------------------------
 1. Create a frontend DTO:  GaugeDataDTO
    -- It holds 4 fields:
                total_pending_reports
                total_wip_reports
                total_completed_reports
                total_reports
                
                
 
 
 2. Create your Chart Service (if you have not already done so)
 
    
 3. Add a method:  getGaugeData()
    -- Nothing is passed-in
    -- It returns an observable of GaugeDataDTO
    -- Inside the fake dto, set the total pending       to 25
                            set total wip reports       to 15
                            set total completed reports = 150
                            set total reports           = 190

          
    
      
      
Part 2 / Create the small guage component
-----------------------------------------
 1. Create the small column chart component:   GaugeSmallComponent
 
 2. Edit the Main Dashboard Page / HTML
    a. Remove the hard-coded "Chart 6"
    b. Add-in the component to your dashboard chart
    c. Make sure your this chart uses 100% of the height and width (of the parent div)
    d. Verify that you see "gauge-small work!" in your dashboard
        
        
        
 
 3. Edit the small gauge component / HTML
    -- There are 3 guages in this small component
    -- Give each div 33% of the page
    -- Give each div a unique id -- e.g., gaugeChart1, gaugeChart2, gaugeChart3
    
              33%             33%             33%
        +-----------------+-----------------+-----------------+
        |   gaugeChart1   |   guargeChart2  |  guargeChart3   |
        |                 |                 |                 |
        |  Total Pending  |    Total WIP    | total Completed |     // NOTE, you do not add these labels in the HTML
        |     Reports     |     Reports     |      Reports    |     // When Highcharts renders the gauge, the label will appear
        +-----------------+-----------------+-----------------+  
           
        Gauge1 will show total pending reports 
        Gauge2 will show total work-in-progress reports
        Gauge3 will show total completed reports   
                         

        
        
 4. Edit the small gauge component / TypeScript
    a. Inject your chartService
 
 
 5. Add the imports for gauges (before the @Component)
    NOTE:  Add additional imports for **GAUGES**
    

        
           
 6. Add a private class variable called chartOptions
        private gaugeChartOptions1: any;
        private gaugeChartOptions2: any;
        private gaugeChartOptions3: any;
        
        
        
        
  
 7. Set the 3 guargeChartOptions object to hold options for these 3 gauges
    a. Go to https://www.highcharts.com/demo/highcharts/gauge-solid
       *OR*
       Go to https://www.highcharts.com/
       Click on Demos
       Select "Gauges" -> "Solid gauge"
       
    b. Press JSfiddle button or "Code"
    c. Copy the configuration from the javaScript
    d. Set your chartOptions variable equal to it
    
       *OR* use this
       
               
          private gaugeChartOptions1: any = {
            chart: {
              type: 'solidgauge'
            },
            pane: {
              center: ['50%', '65%'],
              size: '100%',
              startAngle: -90,
              endAngle: 90,
              background: {
                backgroundColor: '#EEE',
                innerRadius: '60%',
                outerRadius: '100%',
                shape: 'arc'
              }
            },
        
            exporting: {
              enabled: false
            },
            tooltip: {
              enabled: false
            },
        
            // the value axis
            yAxis: {
              min: 0,
              stops: [
                [1, '#800080'] // purple
              ],
              lineWidth: 0,
              tickWidth: 0,
              minorTickInterval: null,
              tickAmount: 2,
              labels: {
                y: 16
              }
            },
            plotOptions: {
              solidgauge: {
                dataLabels: {
                  y: 5,
                  borderWidth: 0,
                  useHTML: true
                }
              }
            },
            credits: {
              enabled: false
            },
            title: {
              text: null           // set the text to null to disable the title
            },
            series: [{
              name: 'Total WIP Reports',
              dataLabels: {
                format:
                  '<div style="text-align:center">' +
                  '<span style="font-size:25px">{y}</span><br/>' +
                  '<span style="font-size:12px;opacity:0.4">Total WIP Reports</span>' +
                  '</div>'
              }
            }]
          };
        
        
          private gaugeChartOptions2: any = {
            chart: {
              type: 'solidgauge'
            },
            pane: {
              center: ['50%', '65%'],
              size: '100%',
              startAngle: -90,
              endAngle: 90,
              background: {
                backgroundColor: '#EEE',
                innerRadius: '60%',
                outerRadius: '100%',
                shape: 'arc'
              }
            },
        
            exporting: {
              enabled: false
            },
        
            tooltip: {
              enabled: false
            },
        
            // the value axis
            yAxis: {
              min: 0,
              stops: [
                [1, '#FF0000'] // red
              ],
              lineWidth: 0,
              tickWidth: 0,
              minorTickInterval: null,
              tickAmount: 2,
              labels: {
                y: 16
              }
            },
            plotOptions: {
              solidgauge: {
                dataLabels: {
                  y: 5,
                  borderWidth: 0,
                  useHTML: true
                }
              }
            },
            credits: {
              enabled: false
            },
            title: {
              text: null           // set the text to null to disable the title
            },
            series: [{
              name: 'Total Pending Reports',
              dataLabels: {
                format:
                  '<div style="text-align:center">' +
                  '<span style="font-size:25px">{y}</span><br/>' +
                  '<span style="font-size:12px;opacity:0.4">Total Pending Reports</span>' +
                  '</div>'
              }
            }]
          };
        
        
          private gaugeChartOptions3: any = {
            chart: {
              type: 'solidgauge'
            },
            pane: {
              center: ['50%', '65%'],
              size: '100%',
              startAngle: -90,
              endAngle: 90,
              background: {
                backgroundColor: '#EEE',
                innerRadius: '60%',
                outerRadius: '100%',
                shape: 'arc'
              }
            },
            exporting: {
              enabled: false
            },
            tooltip: {
              enabled: false
            },
            // the value axis
            yAxis: {
              min: 0,
              stops: [
                [1, '#008000'] // green
              ],
              lineWidth: 0,
              tickWidth: 0,
              minorTickInterval: null,
              tickAmount: 2,
              labels: {
                y: 16
              }
            },
        
            plotOptions: {
              solidgauge: {
                dataLabels: {
                  y: 5,
                  borderWidth: 0,
                  useHTML: true
                }
              }
            },
        
            credits: {
              enabled: false
            },
        
            title: {
              text: null           // set the text to null to disable the title
            },
            series: [{
              name: 'Total Completed Reports',
              dataLabels: {
                format:
                  '<div style="text-align:center">' +
                  '<span style="font-size:25px">{y}</span><br/>' +
                  '<span style="font-size:12px;opacity:0.4">Total Completed Reports</span>' +
                  '</div>'
              }
            }]
          };

    
        
 
   

 8. Create a private method:  reloadData()
    a. This method will invoke a REST call to get the data
    
    
    b. Set the data in the 3 objects
       Set the gaugeChartOption1 / first array element of series / data = total pending reports
       Set the gaugeChartOption1.yAxis.max = total reports
      
       Set the gaugeChartOption2 / first array element of series / data = total wip reports
       Set the gaugeChartOption2.yAxis.max = total reports
       
       Set the gaugeChartOption3 / first array element of series / data = total completed reports
       Set the gaugeChartOption4.yAxis.max = total reports    
       

    c. Tell Highcharts to render the 3 charts
               
   
   
          
 9. After the component has rendered the HTML, call your reloadData() method
        


10. Verify that you see the small gaurge chart in the dashboard page



Part 4 / Create the full-size version of this small guage component
-------------------------------------------------------------------
 1. Setup the Page
    a. Generate the component:                GaugeLargeComponent
    b. Add the route to constants.ts:         the route will be this:   page/dashboard/gauge
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Connect to http://localhost:4200/page/dashboard/gauge
       -- Verify you see "gauge-large works!"
    
       NOTE:  Do *NOT* add it to the navigation bar



 2. Setup this page layout
     +-------------------------------------------------------------------+
     | Gauge Page                                                   Help |
     +-------------------------------------------------------------------+
     |                                                                   |
     |                                                                   |
     +-------------------------------------------------------------------+





 3. Change the bottom of the page so use the VISIBLE height of the browser
     +-------------------------------------------------------------------+
     | Gauge Page                                                   Help |
     +-------------------------------------------------------------------+
     | Chart is here                                                     |   Height of the bottom of page *STRETCHES*
     |                                                                   |
     +-------------------------------------------------------------------+
 

        
        
        
 4. Put your little chart in the big page




 
 5. Edit the Dashboard Page / TypeScript
    a. Inject the router
    
    b. Add a method:  navigateToGaugePage()
       -- This method should take the user to the large gauge page
 

     
    
 6. Edit the Dashboard Page / HTML
    a. Add a click handler to the div around small chart so it calls your method
 
    b. Change the cursor to a pointer if the mouse is over your small chart  (as it is clickable)


           
           
 7. Try it out
    a. Go to the Dashboard Page
    b. Click on the small gaurge chart
       -- It should take you to the full size page


            
```