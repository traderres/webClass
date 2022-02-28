Lesson 16h: Dashboard / Add USA Map
-----------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1KX5IjX4c4ZPb1LZmKscbcC01aeVcljB5oia1Vnl3JvI/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16h/dashboard/add-usa-map
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem: How do we add a map of the USA as a separate page<br>
Solution: Use highcharts on a single page<br>

- This map looks impressive in that it shows information broken down by states in the USA
- This map/chart is a single chart that uses the entire height of the page

<br>
<br>

![](https://lh6.googleusercontent.com/ZgASdubCp94COc_Fjj-pyJqr5EueiPtP_Vy0fnSSakHjL6z3gLxfVhMdGcscRmTkGZGdGpr6s1C7ITSUDdCYxMex-MqoAq0fe7_euqrhV7vNXsi6IMBMMJ-PvpVFHj302crMz0Zi)

<br>
<br>
The usa map data must be broken down by state or territory code 
So, the data looks like this:

```
[
          ['us-md', 26],
          ['us-dc',  39],
          ['us-va', 24]
]
```


<br>
<br>

<h3>Approach</h3>

1. Create a usa-map page

   1. Create the usa-map-component
   1. Add a route
   1. Add it to the Navigation Bar  

1. Setup the page layout using Angular flex

   1. Add a 1st row that holds the page title (with left, center, and right sections)
   1. Add a 2ndrow that holds a mat-card (that holds the usa-map)  

1. Install the "Map Collections" which gives you all of this data:  
   http://code.highcharts.com/mapdata/  

1. Add the usa-map to the page with hard-coded data

   1. Read the map baseline data as a json string from here:  
      @highcharts/map-collection/countries/us/custom/us-all-territories.geo.json  
   1. Create a mapOptions object that has the map data and chart options  
   1. Add a method called "reloadData" that
      1. Sets the map data
      1. Renders the map to a div called "mapContainer"  

   1. Adjust the HTML so that the map uses the entire width  
   1. Remove the border from mat-card and add a 3D effect

<br>
<br>

```

Procedure
---------
    1. Create a usa-map page component, add a route, and add it to the Navigation Bar
        a. Create a new page component called analytics/usa-map
           unix> cd ~/intellijProjects/angluarApp1/frontend
           unix> ng generate component analytics/usa-map --skipTests

        b. Add a route such that "page/usa-map" takes users to your newly created component

        c. Add a navigation icon to the navbar (in the Analytics Section) called "USA Map" that takes users to this route

        d. Verify that the navigation icon works


    2. Install & Verify the Map Collections was installed
        a. Install the Map Collections
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> npm install @highcharts/map-collection

        b. Verify that it was installed
            i. Examine your package.json
            ii. Verify that you see this:
	                "@highcharts/map-collection": "1.1.3",


    3. Make sure this file exists  (as this has the usa map data we need)
       node_modules/@highcharts/map-collection/countries/us/custom/us-all-territories.geo.json


    4. Setup the page layout using Angular flex
        a. Edit usa-map.component.html
        b. Add a wrapper div with a class of "page-container" that has a margin of 10px
        c. Add an angular flex column
            i.  Add row1 as a div that holds page title row (with a left side and right side)
            ii. Add row2 as a div that holds the label "USA Map"

                Hint:  Take a look at your dashboard.component.html for how the layout was setup

        d. Replace "USA Map" with a mat-card and 
           put the label "USA Map" in the <mat-card-content>...</mat-card-content>



    5. Place the div with id="mapContainer" inside the <mat-card-content>
        a. Edit usa-map.component.html

        b. Make sure your single mat-card looks like this:
           NOTE:  We will use the border so we can visually see where the mat-card fits in the page
            
              <mat-card style="border: 1px solid black">
                    <mat-card-content>
            
                        <!-- USA Map -->
                        <div id="mapContainer" style="width: 100%; height: 100%; display: block;"></div>
                
                   </mat-card-content>
              </mat-card>


    6. Have the usa-map page display a render a USA map
        a. Edit usa-map.component.ts

        b. Replace its contents with this:
            
            import {AfterViewInit, Component, OnDestroy, OnInit} from '@angular/core';
            import * as Highcharts from "highcharts";
            import MapModule from 'highcharts/modules/map';
            
            declare var require: any;
            const usaMapDataAsJson =
            require("@highcharts/map-collection/countries/us/custom/us-all-territories.geo.json");
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
            
            
            @Component({
              selector: 'app-usa-map',
              templateUrl: './usa-map.component.html',
              styleUrls: ['./usa-map.component.css']
            })
            export class UsaMapComponent implements OnInit, OnDestroy, AfterViewInit {
            
              public dataIsLoading: boolean = false;
            
              private mapOptions: any = {
                chart: {
                map: usaMapDataAsJson as any
                },
                title: {
                text: "Total Pending Items Per State"
                },
                credits: {
                enabled: false    	// Hide the highcharts.com label
                },
                subtitle: {
                text:
                    'Source map: United States, FeatureCollection</a>'
                },
                mapNavigation: {
                enabled: true,
                buttonOptions: {
                    alignTo: "spacingBox"
                }
                },
                legend: {
                enabled: true
                },
                colorAxis: {
                min: 0
                },
                series: [
                {
                    type: "map",
                    name: "Total Pending Items",
                    states: {
                    hover: {
                        color: "#BADA55"
                    }
                    },
                    dataLabels: {
                    enabled: true,
                    format: "{point.name}<br>{point.value:,.0f}"	// Format the point.value with commas
                    },
                    allAreas: false,
                    data: []
                }
                ],
            
                exporting: {
                buttons: {
                    contextButton: {
                    menuItems:  [
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
            
            
              ngOnInit(): void {
            
                // Set the thousands separator as a comma for all charts
                Highcharts.setOptions({
                lang: {
                    thousandsSep: ','
                }
                });
            
              }
            
              ngAfterViewInit(): void {
                this.reloadData();
              }
            
              ngOnDestroy(): void {
              }
            
              public reloadData(): void {
                // Tell the template page that data is loading (so it will show the spinners)
                this.dataIsLoading = true;
            
                // Update the Map with the state information
                this.mapOptions.series[0].data =  [
                ['us-ma', 0],
                ['us-wa', 1],
                ['us-ca', 2],
                ['us-or', 3],
                ['us-wi', 4],
                ['us-me', 5],
                ['us-mi', 6],
                ['us-nv', 7],
                ['us-nm', 8],
                ['us-co', 9],
                ['us-wy', 10],
                ['us-ks', 11],
                ['us-ne', 12],
                ['us-ok', 13],
                ['us-mo', 14],
                ['us-il', 15],
                ['us-in', 16],
                ['us-vt', 17],
                ['us-ar', 18],
                ['us-tx', 19],
                ['us-ri', 20],
                ['us-al', 21],
                ['us-ms', 22],
                ['us-nc', 23],
                ['us-va', 24],
                ['us-ia', 25],
                ['us-md', 26],
                ['us-de', 27],
                ['us-pa', 28],
                ['us-nj', 29],
                ['us-ny', 30],
                ['us-id', 31],
                ['us-sd', 32],
                ['us-ct', 33],
                ['us-nh', 34],
                ['us-ky', 35],
                ['us-oh', 36],
                ['us-tn', 37],
                ['us-wv', 38],
                ['us-dc', 39],
                ['us-la', 40],
                ['us-fl', 41],
                ['us-ga', 42],
                ['us-sc', 43],
                ['us-mn', 44],
                ['us-mt', 45],
                ['us-nd', 46],
                ['us-az', 47],
                ['us-ut', 48],
                ['us-hi', 49],   // Hawaii
                ['us-ak', 50],   // Alaska
                ['gu-3605', 51],
                ['mp-ti', 52],
                ['mp-sa', 53],
                ['mp-ro', 54],
                ['as-6515', 55],
                ['as-6514', 56],
                ['pr-3614', 57],
                ['vi-3617', 58],
                ['vi-6398', 59],
                ['vi-6399', 60]
                ];
            
                // Render the map
                Highcharts.mapChart('mapContainer', this.mapOptions);
            
                this.dataIsLoading = false;
              }
            
            }
            

    7. Verify the map shows
        a. Activate the Debugger on "Full WebApp"
        b. Click on "USA Map"
        c. You should see this:
```
![](https://lh6.googleusercontent.com/99GxbU5790-XAP30w-HCkb25OubIrHyZGmGWgm6T7Gc1rBK1Fochz11agQxMyj7vkoLABx36sWC6d4VPqkjdHgspvP0Ru9pc8viNMOXptq38BZJ5v83wibgZo7eOJiRI5DEiz9NJ)
```
The map renders in the mat-card
The black border shows you where the mat-card is placed.





    8. Problem:  The map does not use the entire page height
                 The map uses 100% height of the mat-card-content tag
       Solution:  We need a wrapper div that will use all of the height.

        a. Edit usa-map.component.html

        b. Add this wrapper div around the 
            
              <mat-card style="border: 1px solid black">
                  <mat-card-content>
            
                    <!-- Setup a wrapper div that uses the entire available height (total height - 165px) -->
                    <div style="height: calc(100vh - 165px);">
            
                           <!-- USA Map -->
                           <div id="mapContainer" style="width: 100%; height: 100%; display: block;"></div>
                         
                    </div>
            
                  </mat-card-content>
              </mat-card>



    9. Verify the map uses the entire height of the page
        a. Activate the Debugger on "Full WebApp"
        b. Click on "USA Map"
        c. Verify the USA map uses the entire height of the page  (and no scrollbar appears)
        d. Resize the browser:  The map should adjust in size and no scrollbars should appear.
```
![](https://lh6.googleusercontent.com/ANc40JzT_sF6IqicLTo1AXgZKqRy9kNmEriE5vDVlgkq8Dwbll4EAPER7Q9xNJuaL_wEhsT0WBoWzLEaQIh-L34afxg3rgNij7kisnrXZrrHU5CyOAkcItcrBJY_j4d9AVA-7veJ)
```
Now, the USA-map uses the entire height of the page
NOTE:  There is no no scrollbar (even if you adjust the page) 




    10. Remove the border around the mat-card and replace it with a z4 elevation
        a. Edit usa-map.component.html

        b. Remove the border from the <mat-card> tag

        c. Add class="mat-elevation-z4" to the mat-card


    11. Verify that the map fills the entire mat-card and the mat-card has a mat-elevation-z4 effect
        a. Activate the Debugger on "Full WebApp"
        b. Click on "USA Map"
        c. Verify that you see the 3D effect around the mat-card
```
![](https://lh6.googleusercontent.com/ZgASdubCp94COc_Fjj-pyJqr5EueiPtP_Vy0fnSSakHjL6z3gLxfVhMdGcscRmTkGZGdGpr6s1C7ITSUDdCYxMex-MqoAq0fe7_euqrhV7vNXsi6IMBMMJ-PvpVFHj302crMz0Zi)
```
Now, the USA map has a 3D effect around it (instead of a solid black line border)

NOTE:  Double-click on a section of a map to zoom-in.




    12. Problem:  I zoomed-in but there is no button to reset the zoom
        Solution:  Create a custom menu that reloads the map  (which puts the zoom back to the original)

        a. Edit usa-map.component.ts

        b. Create a custom context menu option called "Reset Zoom" that calls this.reloadData()
           
            Change the exporting section by adding a new menu option   (changes in bold)
            
            exporting: {
                buttons: {
                        contextButton: {
                            menuItems:  [
                                'viewFullscreen',
            
                                {
                                    text: 'Reset Zoom',
                                    onclick: () => {
                                        this.reloadData();
                                    }
                                },
            
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

        c. Remove the "mapOptions.series" section from private mapOptions object

        d. Add the "mapOptions.series" when reloading the data 
        


        When finished the reloadData() method looks something like this:
        
          public reloadData(): void {
        
            // Tell the template page that data is loading (so it will show the spinners)
            this.dataIsLoading = true;
        
            // Update the Map with the state information
            this.mapOptions.series = [
            {
                type: "map",
                name: "Total Pending Items",
                states: {
                hover: {
                    color: "#BADA55"
                }
                },
                dataLabels: {
                enabled: true,
                format: "{point.name}<br>{point.value:,.0f}"	// Format the point.value with commas
                },
                allAreas: false,
                data: []
            }
            ];
        
            this.mapOptions.series[0].data =  [
            ['us-ma', 0],
            ['us-wa', 1],
            ['us-ca', 2],
            ['us-or', 3],
            ['us-wi', 4],
        
            . . .
        
            ['vi-6399', 60]
            ];
        
            // Render the map
            Highcharts.mapChart('mapContainer', this.mapOptions);
        
            this.dataIsLoading = false;
          }


    13. Verify the "Reset Zoom" menu works
        a. Activate the Debugger on "Full WebApp"
        b. Click on "USA Map"
        c. Double-click on a section of the map to zoom-in
        d. Press the "Reset Zoom" menu button
```
![](https://lh3.googleusercontent.com/468AF9uTnWx33oHKcGAUOpsBx2dDUt0AsVId6vr-xsRhrilXnwkG-tCXAeXbj6HhGipxpkCQ4hGTCH9QGsR8ocGYMwdoLuhPWiauO7i9DWVuI-D9s4RpQsWcgOF3MZAGkT6NgrKb)
```


The map should reset back to the default page
```
![](https://lh3.googleusercontent.com/yui3vIuazGpH-zXZjVnnr3iR0Qq2cqwa5lUVTFuABl3Ah8T9qwdIiAx4Wmtc7Id2CTwux6ODebgLbYoO9iBhxa9j726FMf853A4VnT1nagSEwBBjnX8A1lFg6EhaRsA7e491WVnU)
