Lesson 22d:  Ag Grid / Client Side / Loading Data via Service
-------------------------------------------------------------
The Google Drive link is here:<br>
https://docs.google.com/document/d/1-ETxerTz9JGdmm1aMbkbvPZbA3uMP-10YVAUzBIqRDc/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson22d/grid/load-data
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem 1:  I want to load the grid from a REST call AND <br>
Problem 2:  I cannot load data until the grid is fully initialized<br>
Problem 3:  The ag-grid docs has lots of API calls that refer to api or columnApi<br>
    I need a reference to these variables<br><br>

Solution:  Use the onGridReady event handler to load the data AND to get a reference to the gridApi


<br>
<br>
Here are some of ag-grid's documentation<bR>
The url is here:  
&nbsp;&nbsp;&nbsp;https://www.ag-grid.com/angular-grid/row-selection/ <br><br>

![](https://lh3.googleusercontent.com/MzZ-s0WFUkJW_a_foq6iiwfcNYG1idmCR5yA2zqVTIKo3lAtdC60TKBNF45LSVh-tasRZr3T8VXjIReEAWFX-fo5VNR1tEXEp5iZZ-U1pyzvNw3B2ebX2s1n2OseuGyhvkvqNUn5)

```
The api.getSelectedRows() refers to this.gridApi.getSelectedRows() in our code


Procedure
---------
    1. Create a DTO that represents one row of data
        a. Create this front-end class:   ReportRowDataDTO (in the models/ directory)

        b. Add these fields to it
               id		    numeric field
               name     	text field
               priority	    text field
               start_date	text field
               end_date	    text field



    2. Create a GridService (that has a method that will simulate a REST call)
        a. Create this front-end service:  GridService      (in the services/ directory)

        b. Add a public method:  getReportData() 
           NOTE:  This method returns an observable that holds an array of ReportRowDataDTO

        c. Fill-in this public method
            i.  Create a variable that holds the array of hard-coded data
                HINT:  Take it from the report-grid-view.component.ts

            ii. Return the variable using the of() method so it's wrapped as an observable



    3. Adjust the ReportGridViewComponent to use the GridService
        a. Edit report-grid-view.component.ts


        b. Inject the GridService


        c. Change the public rowData variable so it's just a variable (no hard-coded data)
           NOTE:  The rowData will hold an array of ReportRowDataDTO objects


        d. Add these 2 public variables (as we will use them later):  
              private gridApi: GridApi;
              private gridColumnApi: ColumnApi;
  

        e. Tell the grid to call your method when it has fully initialized
            i. Edit report-grid-view.component.ts

            ii. Add a public method called onGridReady() to your Grid Component class
                
                  public onGridReady(params: any): void {
                    // Get a reference to the gridApi and gridColumnApi (which we will need later to get selected rows)
                    this.gridApi = params.api;
                    this.gridColumnApi = params.columnApi;
                
                    // Show the loading overlay
                    this.gridApi.showLoadingOverlay();
                
                    // Invoke a REST call to get data for the initial page load
                    this.gridService.getReportData().subscribe((aData: ReportRowDataDTO[]) => {
                        // We got data from the REST call
                
                        // Put the data into the grid
                        this.rowData = aData;
                
                        // Resize the columns
                        this.gridApi.sizeColumnsToFit();
                
                        // Reset row heights
                        this.gridApi.resetRowHeights();
                
                        // Tell the grid to resize when user resizes the browser window
                        window.onresize = () => {
                                this.gridApi.sizeColumnsToFit();
                        }
                
                    });
                
                }    // end of onGridReady()



    4. Adjust the <ag-grid-angular> so that it calls your public method when it's ready
        a. Edit report-grid-view.component.html

        b. Change the <ag-grid-angular> tag to call our method when the grid has initialized
                 (gridReady)="this.onGridReady($event)"

        
        
        When finished, your ag-grid tag should look something like this:
        
        <!-- AG-Grid -->
        <ag-grid-angular
              style="width: 100%; height: 100%"
              class="ag-theme-alpine"
              [rowData]="this.rowData"
              [defaultColDef]="this.defaultColDefs"
              [columnDefs]="this.columnDefs"
              [gridOptions]="this.gridOptions"
              (gridReady)="this.onGridReady($event)"   >
        </ag-grid-angular>
        
        
        

    5. Verify that the grid loads data from a REST call
        a. Activate the Debugger on "Full WebApp"
        b. Go to the Reports Grid View
           -- The grid should appear

```
