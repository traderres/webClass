```
Exercise 11b / Client Grid / Load the grid with a frontend service (Answers)
----------------------------------------------------------------------------
Problem:  I want to load the grid from a REST call
Solution: Once the grid is initialized, invoke the REST call to load the grid

```
![](../images/exercise11b_image2.png)
```


Exercise
--------
 1. Setup the Page
    a. Generate the component:                Call it MySearchesGrid
    b. Add the route to constants.ts:         the route will be this:   page/reports/my-searches
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Add a link to the navbar (using that route)
    f. Use the debugger to verify that the navbar link works



 2. Setup this page layout
     +-------------------------------------------------------------------+
     | My Searches                                                  Help |
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
                <span class="text-xl">My Searches</span>
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
     | My Searches                                                  Help |
     +-------------------------------------------------------------------+
     | Grid is here                                                      |   Height of the bottom of page *STRETCHES*
     |                                                                   |
     +-------------------------------------------------------------------+
 
        <div class="m-2.5">
        
          <div class="grid grid-cols-2">
              <div>
                <span class="text-xl">My Searches</span>
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


 
    
Part 2 / Configure the gridOptions, columnDefs, defaultColumnDefs, and rowData
-------------------------------------------------------------------------------
 1. Add a public class variable:   gridOpptions
    -- The type is GridOptions
    
    -- Set these properties
        domLayout: 'normal',            // Requires the wrapper div to have a height set *OR* a class="h-full" on it
        debug: false,
        rowModelType: 'clientSide',   
        
        
        public gridOptions: GridOptions = {
          domLayout: 'normal',
          debug: true,
          rowModelType: 'clientSide'
        };
        
        
 2. Add a public class variable:  columnDefs
    -- The type is array of ColDef objects
    
    -- Initialize the array to hold an object for each column definition
    
    a. Define columnDefs to hold an array of 4 objects
        the field names will be
                id
                name
                search_query
                last_executed_date
                


            public columnDefs: ColDef[] = [
              {
                field: 'id'
              },
              {
                field: 'name'
              },
              {
                field: 'search_query'
              },
              {
                field: 'last_executed_date'
              }
            ];                
                
                
 3. Add a public class variable:  defaultColumnDef
    -- The type is ColDef
    -- Initialize it so that flex = 1, sortable = true, filter = true, floatingFilter = true

        public defaultColumnDef: ColDef = {
          flex: 1,
          sortable: true,
          filter: true,
          floatingFilter: true
        }
        
        
                
 
 
 6. Add the <ag-grid-angular> tag to your HTML 
    -- Place it where you want your grid to appear
    
    
 
 7. Tell the ag-grid-angular to use your class variables
    -- Set gridOptions property     to your public class variable
    -- Set columnDefs property      to use your public class variable
    -- Set defaultColDef property   to use your public class variable
    -- Set the grid to use 100% of the width 
    -- Set the grid to use 100% of the height
    -- Apply the ag-theme-alpine class to the grid (to set the grid's theme to "alpine"
    
        <ag-grid-angular
          [gridOptions]="this.gridOptions"
          [columnDefs]="this.columnDefs"
          [defaultColDef]="this.defaultColumnDef"
        ></ag-grid-angular>


        -- At this point, the grid is shows "Loading..." because there is nothing
```
![](../images/exercise11b_image1.png)
```




Part 3 / Create the Frontend Service that will simulate a REST call (fake service)
----------------------------------------------------------------------------------
 1. Create a frontend DTO:  SavedSearchDTO
        id                  // This is numeric
        name                // Every will hold text
        search_query        // Every will hold text 
        last_executed_date  // This will hold text -- e.g., '05/01/2024'
   
   
        export class SavedSearchDTO {
          public id:                 number;
          public name:               string;
          public search_query:       string;
          public last_executed_date: string;
        }


 2. Create a frontend service:  MySearchService
     a. Create this front-end service:  MySearchService 
     
     b. Add a public method:  getUsersSavedSearches() 
        NOTE:  This method returns an observable that holds an array of SavedSearchDTO

     c. Fill-in this public method
        1) Create a local variable that holds an array of SavedSearchDTO objects 
        2) Fill-in the array with 3 fake objects
        3) Convert the array into an observable
        4) Return the observable

        
          public getUsersSavedSearches(): Observable<SavedSearchDTO[]> {
            let data: SavedSearchDTO[] = [
              {
                id: 1,
                name: 'Reported created in 2024',
                search_query: "created_date >= '01/01/2024'",
                last_executed_date: '07/01/2024'
              },
        
              {
                id: 2,
                name: 'Most popular reports',
                search_query: "most_popular(report)",
                last_executed_date: '07/02/2024'
              },
              {
                id: 3,
                name: 'Reported created in 2023',
                search_query: "created_date >= '01/01/2023 AND created_date < 01/01/2024'",
                last_executed_date: '07/05/2024'
              },
            ];
            
            return of(data);
          }



Part 4 / Configure the grid to load it's rowData with the fake service
----------------------------------------------------------------------
 1, In the Grid Page TypeScript / Inject your MySearchService
 
        public constructor(private MySearchService: MySearchService) { }
 
 
 
 2. In the Grid Page TypeScript / Add these 2 public class variables:
        gridApi / type is GridApi
        gridColumnApi / type is ColumnApi
    
    
    
 3.  In the Grid Page TypeScript / Add a method:  onGridReady
    -- Pass-in aParams / type is GridReadyEvent
    -- initialize this.gridAPi
    -- initialize this.gridColumnApi
    -- Use the gridApi to show the "loading overlay"
    -- Invoke the fake REST call (you made in the previous step)
    -- When the REST call comes in, set the grid row data
    
    
 
 4. In the HTML, tell the grid to call your onGridReady() when the grid is fully initialized
 
       (gridReady)="this.onGridReady($event)"



```
![](../images/exercise11b_image2.png)
```

    The Completed MySearchService looks like this
    ---------------------------------------------
    import { Injectable } from '@angular/core';
    import {SavedSearchDTO} from "../models/saved-search-dto";
    import {Observable, of} from "rxjs";
    
    @Injectable({
      providedIn: 'root'
    })
    export class MySearchService {
    
      constructor() { }
    
      public getUsersSavedSearches(): Observable<SavedSearchDTO[]> {
        let data: SavedSearchDTO[] = [
          {
            id: 1,
            name: 'Reported created in 2024',
            search_query: "created_date >= '01/01/2024'",
            last_executed_date: '07/01/2024'
          },
    
          {
            id: 2,
            name: 'Most popular reports',
            search_query: "most_popular(report)",
            last_executed_date: '07/02/2024'
          },
          {
            id: 3,
            name: 'Reported created in 2023',
            search_query: "created_date >= '01/01/2023 AND created_date < 01/01/2024'",
            last_executed_date: '07/05/2024'
          },
        ];
    
        return of(data);
      }
    
    }



    The Completed TypeScript looks like this
    ----------------------------------------
    import { Component } from '@angular/core';
    import {ColDef, ColumnApi, GridApi, GridOptions, GridReadyEvent} from "ag-grid-community";
    import {SavedSearchDTO} from "../../models/saved-search-dto";
    import {MySearchService} from "../../services/my-search.service";
    
    @Component({
      selector: 'app-my-searches-grid',
      templateUrl: './my-searches-grid.component.html',
      styleUrls: ['./my-searches-grid.component.scss']
    })
    export class MySearchesGridComponent {
    
      public constructor(private mySearchService: MySearchService) {
    
      }
    
      private gridApi: GridApi;
      private gridColumnApi: ColumnApi;
    
      public gridOptions: GridOptions = {
        domLayout: 'normal',
        debug: true,
        rowModelType: 'clientSide'
      };
    
    
      public columnDefs: ColDef[] = [
        {
          field: 'id'
        },
        {
          field: 'name'
        },
        {
          field: 'search_query'
        },
        {
          field: 'last_executed_date'
        }
      ];
    
    
      public defaultColumnDef: ColDef = {
        flex: 1,
        sortable: true
      }
    
    
      public onGridReady(aParams: GridReadyEvent) {
        // Get a reference to the gridApi and gridColumnApi (which we will need later to get selected rows)
        this.gridApi = aParams.api;
        this.gridColumnApi = aParams.columnApi;
    
        // Show the loading overlay
        this.gridApi.showLoadingOverlay();
    
        // Invoke the REST call to get the grid data
        this.mySearchService.getUsersSavedSearches().subscribe( (aData: SavedSearchDTO[]) => {
          // REST call came back with data
    
          // Load the grid with data from the REST call
          this.gridApi.setRowData(aData);
        })
    
      }
    
    }

 
 
    The Completed HTML looks like this
    ----------------------------------
    <div class="m-2.5">
    
      <div class="grid grid-cols-2">
        <div>
          <span class="text-xl">My Searches</span>
        </div>
    
        <div class="flex place-content-end">
          Help
        </div>
      </div>
    
      <div class="mt-2.5">
        <!-- Add Grid Here -->
        <div class="overflow-y-auto" style="height: calc(100vh - 150px)">
    
          <ag-grid-angular class="w-full h-full ag-theme-alpine"
            [gridOptions]="this.gridOptions"
            [columnDefs]="this.columnDefs"
            [defaultColDef]="this.defaultColumnDef"
            (gridReady)="this.onGridReady($event)"
          ></ag-grid-angular>
    
        </div>
    
      </div>
    
    
    </div>

 
```
