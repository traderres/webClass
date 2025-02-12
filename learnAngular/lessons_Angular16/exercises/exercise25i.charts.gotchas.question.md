```
Exercise 25i / Highcharts Gotchas
---------------------------------
Question:  What are some of the better Highcharts practices to follow?   
           What are some of the worst Highcharts practices to avoid?     

Answers:
 -- Destroy all charts when leaving a page.
 -- Use unique css IDs across the entire web application




Good Practice:  Remove Warnings
-------------------------------
Warning #1:    My map works but I get a warning about Error #21, Can't find Proj4js library
Possible Fix:  Make sure your map uses the TopoJSON (instead of regular JSON) file
               Highcharts now prefers TopoJSON maps
               TopoJSON is an extension of GeoJSON that encodes topology. Rather than representing geometries discretely,
              
              
Warning #2:    My map shows a console warning about accessibility 
               Cnsider including the "accessibility.js" module to make your chart more usable for people with disabilities...
Possible Fix:  Disable the accessibility warning
    
                  private chartOptions: any = {
                        accessibility: {
                            enabled: false
                        },
                        
                        ....
                  }
                 
             
        

Good Practice:  Destroy all charts when leaving a page view
-----------------------------------------------------------
Every chart page should have an ngOnDestroy() method that destroys all charts on that page

 1. Take an existing chart page
 
 2. Add the implements OnDestry to the class
 
 3. Add a public ngOnDestroy method
    -- Have it loop through all charts on that page, destroying each one
    
          public ngOnDestroy(): void {
          
            // Destroy all charts on this page
            Highcharts.charts.forEach( (chart: Chart | undefined) => {
              if (chart) {
                chart.destroy();
              }
            });
            
          }



Good Practice:   Give each chart div a UNIQUE ID ACROSS ALL PAGES in your angular app
-------------------------------------------------------------------------------------
 1. Examine your small component HTML
    -- Make sure each div is unique across ALL PAGES



```