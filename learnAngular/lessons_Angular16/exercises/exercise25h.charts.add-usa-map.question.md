```
Exercise 25h / Add a MAP of the USA
-----------------------------------
Problem:  I have data broken down by the 50 USA states and territories
          And, I want to display darker colors for higher numbers in those states


```
![](../images/exercise25h_image1.png)
```

Part 1 / Install the Highcharts "Map Collerctions"
--------------------------------------------------
 1. Look at the different map collections that are available for download
    Go to https://code.highcharts.com/mapdata/
    
 2. Install the "Map Collections" frontend library to the project
    terminal> cd frontend
    terminal> npm install @highcharts/map-collection
 
 3. Verify that it was installed correctly
    -- Look at your package.json
    -- You should see this:
            "@highcharts/map-collection": "^2.3.0",

 4. Remove the carrot from the package.json entry
            "@highcharts/map-collection": "2.3.0",
  
     
 5. Verify that the us-all-territories.geo.json is found here:
    -- Verify this file exists
          angularApp16/frontend/node_modules/@highcharts/map-collection/countries/us/custom/us-all-territories.geo.json
    
    



Part 2 / Update your ChartService to it has a method to return the usa map data
-------------------------------------------------------------------------------
 1. Create your Chart Service (if you have not already done so)
    -- Inject the httpClient  (if you have not already done so)
    
 2. Add a method:  getUsaMapData()
    -- Nothing is passed-in
    -- It returns an observable with the data
    --  Have this method invoke a REST call to 
           https://www.highcharts.com/samples/data/us-population-density.json
           

    
      
      
Part 3 / Create the small map component
---------------------------------------
 1. Create the small column map component:   UsaMapSmallComponent
 
 2. Edit the Main Dashboard Page / HTML
    a. Remove the hard-coded "Chart 5"
    b. Add-in the component to your dashboard chart
    c. Make sure your this map uses 100% of the height and width (of the parent div)
    d. Verify that you see "usa-map-small work!" in your dashboard
        
        
        
 
 3. Edit the small USA map component / HTML
    NOTE:  The entire HTML is just a div with a unique ID -- e.g., "usaMap"
           The div should use 100% of the height and width
               

        
        
 4. Edit the small USA map component / TypeScript
    a. Inject your chartService
 
 
 5. Add the imports for maps (before the @Component)
 
        import * as Highcharts from "highcharts";
        import MapModule from 'highcharts/modules/map';
        
        MapModule(Highcharts);
        
        // Turn on the highchart context menu *View/Print/Download* options
        //  -- Gives you these menu options: View in Full Screen, Print Chart, Download PNG, Download JPEG, Download PDF, Download SVG
        import HC_exporting from 'highcharts/modules/exporting';
        HC_exporting(Highcharts);
        
        // Turn on the highchart context menu *export* options
        // -- Gives you these menu options: Download CSV, Download XLS, View Data Table
        import HC_exportData from 'highcharts/modules/export-data';
        HC_exportData(Highcharts);
        
        // Do client-side exporting (so that calls do *NOT* go to https://export.highcharts.com/ but does not work on all browsers
        import HC_offlineExport from 'highcharts/modules/offline-exporting';
        HC_offlineExport(Highcharts);
        
        // Read the JSON (stored in us-all-territories.geo.json) into a variable called usaMapDataAsJson
        // @ts-ignore
        import usaMapDataAsJson from "@highcharts/map-collection/countries/us/custom/us-all-territories.geo.json";
                       

           
 6. Add a private class variable called chartOptions
        
  
 7. Set the mapOptions to hold map options for this map
    a. Go to https://www.highcharts.com/demo/maps/color-axis
       *OR*
       Go to https://www.highcharts.com/
       Click on Demos
       Select "Maps" -> "General" -> Color axis and data labels"
       
    b. Press JSfiddle button or "Code"
    c. Copy the configuration from the javaScript
    d. Set your mapOptions variable equal to it
    e. Change the mapOptions.chart.map to hold the usaMapDataAsJson
    
    
 
 8. Edit the mapOptions object:  
    -- Remove the data
    
   

 9. Create a private method:  reloadData()
    a. This method will invoke a REST call to get the data
    
    b. Convert the returned code to upper case  
    
    c. set the data section of your mapOptions object

    e. Tell Highcharts to render the map in the div called "usaMap"
               
    
          
          
          
10. After the component has rendered the HTML, call your reloadData() method
        
   


11. Verify that you see the map in the dashboard page




Part 4 / Create the full-size version of this small map component
-----------------------------------------------------------------
 1. Setup the Page
    a. Generate the component:                UsaMapLargeComponent
    b. Add the route to constants.ts:         the route will be this:   page/dashboard/usa-map
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Use the debugger to verify that the navbar link works
    
    
    NOTE:  Do *NOT* add it to the navigation bar


 2. Setup this page layout
     +-------------------------------------------------------------------+
     | USA Map                                                      Help |
     +-------------------------------------------------------------------+
     |                                                                   |
     |                                                                   |
     +-------------------------------------------------------------------+





 3. Change the bottom of the page so use the VISIBLE height of the browser
     +-------------------------------------------------------------------+
     | USA Map                                                      Help |
     +-------------------------------------------------------------------+
     | Map is here                                                       |   Height of the bottom of page *STRETCHES*
     |                                                                   |
     +-------------------------------------------------------------------+
 
  
        
        
        
 4. Put your little map in the big page





 
 5. Edit the Dashboard Page / TypeScript
    a. Inject the router
    
    b. Add a method:  navigateToUsaMapPage()
       -- This method should take the user to the large map page
 
  
     
    
 6. Edit the Dashboard Page / HTML
    a. Add a click handler to the div around small column map so it calls your method
 
    b. Change the cursor to a pointer if the mouse is over your new map  (as it is clickable)
     

           
           
 7. Try it out
    a. Go to the Dashboard Page
    b. Click on the small map
       -- It should take you to the full size page



 8. Correct the problem with the hamburger
    Problem:  Clicking on the hamburger in the large column map page causes scrollbars to appear
    

```