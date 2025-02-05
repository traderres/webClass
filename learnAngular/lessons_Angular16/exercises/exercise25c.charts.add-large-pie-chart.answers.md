```
Exercise 25c / Clcking on the Little Pie Chart takes you to a Pie Chart Page  (Answer)
--------------------------------------------------------------------------------------
Goal:  If a user clicks on the little pie chart, open this full-size pie chart page

```
![](../images/exercise25c_image1.png)
```



Exercise
--------
 1. Setup the Page
    a. Generate the component:                PieChartLarge
    b. Add the route to constants.ts:         the route will be this:   page/dashboard/pie-chart
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Use the debugger to verify that the navbar link works
    
    
    NOTE:  Do *NOT* add it to the navigation bar


 2. Setup this page layout
     +-------------------------------------------------------------------+
     | Pie Chart Page                                               Help |
     +-------------------------------------------------------------------+
     |                                                                   |
     |                                                                   |
     +-------------------------------------------------------------------+


     At this point, the HTML looks like this
     ---------------------------------------      
        <div class="m-2.5">
        
         <!-- Top of Page -->
          <div class="grid grid-cols-2">
              <div>
                <span class="text-xl">Pie Chart Page</span>
              </div>
        
              <div class="flex place-content-end">
                 Help
              </div>
          </div>
        
          <!-- Bottom of Page  -->
          <div class="mt-2.5">
              
            
          </div>
        
        </div>



 3. Change the bottom of the page so use the VISIBLE height of the browser
     +-------------------------------------------------------------------+
     | Pie Chart Page                                               Help |
     +-------------------------------------------------------------------+
     | Chart is here                                                     |   Height of the bottom of page *STRETCHES*
     |                                                                   |
     +-------------------------------------------------------------------+
 
        <div class="m-2.5">
        
          <div class="grid grid-cols-2">
              <div>
                <span class="text-xl">Pie Chart Parge</span>
              </div>
        
              <div class="flex place-content-end">
                 Help
              </div>
          </div>
        
          <div class="mt-2.5">
              <!-- Add Grid Here -->
              <div class="overflow-y-auto" style="height: calc(100vh - 150px)">
        
                Grid is here
        
              </div>
        
          </div>
        
        
        </div>
        
        
        
 4. Put your little pie chart in the big page

        <div class="m-2.5">
        
          <div class="grid grid-cols-2">
            <div>
              <span class="text-xl">Pie Chart Page</span>
            </div>
        
            <div class="flex place-content-end">
              Help
            </div>
          </div>
        
          <div class="mt-2.5">
            <!-- Add Grid Here -->
            <div class="overflow-y-auto" style="height: calc(100vh - 150px)">
        
                <!-- C H A R T     1  -->
                <app-pie-chart-small class="h-full w-full"></app-pie-chart-small>
        
            </div>
        
          </div>
        
        </div>




 
 5. Edit the Dashboard Page / TypeScript
    a. Inject the router
    b. Add a method:  navigateToPieChartPage()
       -- This method should take the user to the large pie chart page
 
        public navigateToPieChartPage(): void {
            this.router.navigate([Constants.PIE_CHART_PAGE_ROUTE]).then()
        }
  
     
    
 8. Edit the Dashboard Page / HTML
    a. Add a click handler to the div around pie chart 1 so it calles navigateToPieChartPage()
 
         <div class="w-[400px] h-[200px] mat-elevation-z4 p-2.5 cursor-pointer" (click)="this.navigateToPieChartPage()">
            <!-- C H A R T     1  -->
            <app-pie-chart-small class="h-full w-full"></app-pie-chart-small>
        </div>
        
           
    
 9. Edit the Dashboard Page / HTML
     a. Change the cursor to a pointer if the mouse is over pie chart 1  (as it is clickable)
     
     
10. Try it out
    a. Go to the Dashboard Page
    b. Click on the pie chart
       -- It should take you to the full size page



Completed Dashboard Page HTML
-----------------------------
<div class="m-2.5">

  <div class="grid grid-cols-2">
    <div>
      <span class="text-xl">Responsive Dashboard Page</span>
    </div>

    <div class="flex place-content-end">
      Help
    </div>
  </div>

  <div class="mt-2.5">
    <!-- Add Grid Here -->
    <div class="overflow-y-auto" style="height: calc(100vh - 150px)">

        <div class="w-[400px] h-[200px] mat-elevation-z4 p-2.5 cursor-pointer" (click)="this.navigateToPieChartPage()">
            <!-- C H A R T     1  -->
            <app-pie-chart-small class="h-full w-full"></app-pie-chart-small>
        </div>

        <div class="w-[400px] h-[200px] mat-elevation-z4 p-2.5">
          Chart 2
        </div>

        <div class="w-[400px] h-[200px] mat-elevation-z4 p-2.5">
          Chart 3
        </div>

        <div class="w-[400px] h-[200px] mat-elevation-z4 p-2.5">
          Chart 4
        </div>

        <div class="w-[400px] h-[200px] mat-elevation-z4 p-2.5">
          Chart 5
        </div>

        <div class="w-[400px] h-[200px] mat-elevation-z4 p-2.5">
          Chart 6
        </div>
      </div>

    </div>

</div>

```

