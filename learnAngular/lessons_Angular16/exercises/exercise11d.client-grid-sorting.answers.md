```
Exercise 11d / Client Grid / Sorting  (Answers)
-----------------------------------------------
Problem 1:  In client-Side Grids, How do I sort on text fields?
Problem 2:  In client-side grids, How do I sort on date fields?




```
![](../images/exercise11d_image1.png)
```


Exercise
--------
 1. Setup the Page
    a. Generate the component:                Call it GridPageWithSorting
    b. Add the route to constants.ts:         the route will be this:   page/grid-page-with-sorting
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Add a link to the navbar (using that route)
    f. Use the debugger to verify that the navbar link works



 2. Setup this page layout
     +-------------------------------------------------------------------+
     | Grid Page with Sorting                                       Help |
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
                <span class="text-xl">Grid Page with Sorting</span>
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
     | Grid Page with Sorting                                       Help |
     +-------------------------------------------------------------------+
     | Grid is here                                                      |   Height of the bottom of page *STRETCHES*
     |                                                                   |
     +-------------------------------------------------------------------+
 
        <div class="m-2.5">
        
          <div class="grid grid-cols-2">
              <div>
                <span class="text-xl">Grid Page with Sorting </span>
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

 
 
 4. Add a public class variable:   gridOpptions
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
        
        
  5. Add a public class variable:  columnDefs
    -- The type is array of ColDef objects
    
    -- Initialize the array to hold an object for each column definition
    
    a. Define columnDefs to hold an array of 5 objects
        the field names will be
                id
                contract_name
                cage_code
                start_date
                end_date



            public columnDefs: ColDef[] = [
              {
                field: 'id'
              },
              {
                field: 'contract_name'
              },
              {
                field: 'cage_code'
              },
              {
                field: 'start_date'
              },
              {
                field: 'end_date'
               }
            ];                
            
 6. Add class variables to TURN ON FILTERS on all columns
    a. Add a class variable:  textFilterParams     
        
             // Customize the filters (when turned on)
             private textFilterParams: ITextFilterParams = {
                filterOptions: ['contains', 'notContains'],         // Customize the filter to only show "Contains" and "Not Contains"
                caseSensitive: false,                               // Filter is case-insensitive
                debounceMs: 200,
                suppressAndOrCondition: true,
              };
      
    b. Add a class variable:  defaultColumnDefs
       -- The type is ColDef
       -- Initialize it so that flex = 1, sortable = true, filter = true, floatingFilter = true

            public defaultColumnDef: ColDef = {
                flex: 1,
                floatingFilter: true,                   // Show the floating filter (beneath the column label)
                filter: 'agTextColumnFilter',           // Specify the type of filter
                filterParams: this.textFilterParams,    // Customize the filter
            }
                
            
        
 
 7. Create a DTO:  GridSortingRowDataDTO
        id                   // This is numeric
        contract_name        // This will hold text
        cage_code            // This will hold text -- e.g., 'ABCDE'
        start_date           // This will hold text -- e.g., '05/01/2024'
        end_date             // This will hold text -- e.g., '06/01/2024'
   
   
        export class GridSortingRowDataDTO {
          public id:               number;
          public contract_name:    string;
          public cage_code:        string;
          public start_date:       string;
          public end_date:         string;
        }


                 
 7. Add a public class variable:  rowData
    -- The type is an array of GridSortingRowDataDTO objects
    -- Initialize this to be an array of 3 objects
    -- Put in some fake data
               
        public rowData: GridSortingRowDataDTO[] = [
            {
              id: 1,
              contract_name: 'Contract 1',
              cage_code: '6KY98',
              start_date: '05/01/2024',
              end_date: '06/01/2024'
            },
            {
              id: 2,
              contract_name: 'Contract 2',
              cage_code: '51GJ3',
              start_date: '07/01/2024',
              end_date: '07/01/2024'
            },
            {
              id: 3,
              contract_name: 'Contract 3',
              cage_code: '66F66',
              start_date: '08/01/2024',
              end_date: '08/01/2024'
            },
          ];
      
 
 8. Add the <ag-grid-angular> tag to your page 
    -- Place it where you want your grid to appear
    
    
 
 9. Tell the ag-grid-angular to use your class variables
    -- Set gridOptions property     to your public class variable
    -- Set columnDefs property      to use your public class variable
    -- Set defaultColDef property   to use your public class variable
    -- Set rowData property          to use your public class variable
    -- Set the grid to use 100% of the width 
    -- Set the grid to use 100% of the height
    -- Apply the ag-theme-alpine class to the grid (to set the grid's theme to "alpine"
    
        <ag-grid-angular
          [gridOptions]="this.gridOptions"
          [columnDefs]="this.columnDefs"
          [defaultColDef]="this.defaultColumnDef"
          [rowData]="this.rowData"
        ></ag-grid-angular>



10. Change the column headers so it shows "Start Date" instead of "Start_date"
    Change the column headers so it shows "End Date" instead of "End_date"
    Change the column headers so it shows "CAGE Code" instead of "Cage"
    
        public columnDefs: ColDef[] = [
          {
            headerName: 'Id',
            field: 'id'
          },
          {
            headerName: 'Name',
            field: 'name'
          },
          {
            headerName: 'Priority',
            field: 'priority'
          },
          {
            headerName: 'Start Date',
            field: 'start_date',
          },
          {
            headerName: 'End Date',
            field: 'end_date'
            }
        ];


11. Change the column headers so that all columns are sortable
    
    Approach #1:
        Add sortable: true to each column
        
    Approach #2:
        Add sortable: true to the defaultColumnDefs
           
           
       public defaultColumnDef: ColDef = {
          flex: 1,
          sortable: true,
          filter: true,
          floatingFilter: true
        }
    
    

12. Problem:  The date fields do not sort correctly!!!
    Solution: Build a custom date sorter for this date format:  MM/DD/YYYY
    
    
 
```
