```
Exercise 25d / Load Charts using a Front-end Service
----------------------------------------------------
Problem:  The chart will be loaded from a REST call so it needs to get its data using an observable
Solution: Make a frontend service that returns an observable with the data (in the correct format)

```
![](../images/exercise25d_image1.png)
```


Part 1 / Create a Small Line Component w/hard-coded data
--------------------------------------------------------
 1. Create the line chart component:   LineChartSmallComponent
 
 2. Edit the Main Dashboard Page / HTML
    a. Remove the hard-coded "Chart 2"
    b. Add-in the reference to the newly-created LineChartSmallComponent
    c. Make sure your LineChartSmallComponent uses 100% of the height and width
        
        
 
 3. Edit the line chart component / HTML
    NOTE:  The entire HTML is just a div with a unique ID -- e.g., "chart2"
           The div should use 100% of the height and width
               

        
        
 4. Edit the line chart component / TypeScript
 
 
 
 5. Add the high chart options (before the @Component)

    
    
 6. Add a private class variable called chartOptions
        private charOptions: any;
        
        
  
 7. Set the chartOptions to hold the chart options for a line chart
    a. Go to https://www.highcharts.com/
    b. Click on Demos
    c. Select a line chart you like
       *OR*
       Go to https://www.highcharts.com/demo/highcharts/line-chart
       
    d. Press JSfiddle button
    e. Copy the chart configuration from the javaScript
    f. Set your chartOptions variable equal to it
    
         

 8. Edit the chartOptions object
    -- Remove the series information from it
 
            
 9. Create a private method:  reloadData()
    a. This method set the series on the chartOptions object
         
    b. This method will tell Highcharts to render the chart in the div called "chart2"
               
  
          
10. After the component has rendered the HTML, call your reloadData() method
        

11. Verify that you see the chart in the dashboard page


12. Disable the legend in the chart






Part 2 / Load the Chart with a Frontend Service
-----------------------------------------------
 1. Create a frontend DTO:   GetChart2DataDTO
    -- It should hold name field    (that holds text)
    -- It should hold a data field  (that is an array of numbers/null values)

 
 2. Create a frontend service:  ChartService
 
 3. Add a public method to the ChartService:   getAllDataForChart2()
    -- What is passed-in?  Nothing
    -- What is returned?   Observlable that holds an array of GetChart2DataDTO
 
 
 4. Fill-in the public method:     getAllDataForChart2()
    a. Create a local variable that holds an your fake data
    b. Convert your data into an observable
    c. Return the observable
 


 5. Edit your Line Chart Component / TypeScript
    a. Inject your ChartService
    
    b. Edit the reloadData() by removing the hard-coded data 
    
    c. Edit the reloadData() so it uses your ChartService to load the chartOptions.series info

       -- At this point, the LineChartComponent should not have any hard-coded data
       
```