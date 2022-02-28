Lesson 22g:  Ag Grid / Client Side / Row Selection
--------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1VgSQqGB9LVYk5jLTcOzB9YznleUFcDId9kStWxNBBCs/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson22g/grid/row-selection
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem 1:  I want to add a checkbox so that users can select a row<br>
Problem 2:  I want to know which rows are selected<br>
Problem 3:  I want to create a button that lets users perform an action (but only if rows are selected)<br><br>
<br>
Solution:<br>
- Tell specific columns that you want a checkbox<br>
- Use the gridApi to get a list of selectedRows<br>
<br>

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image1.png)

```
Procedure:  Add Row Selection to your Grid
------------------------------------------
    1. Add a checkbox to the "id" column
        a. Edit report-grid-view.component.ts

        b. Edit the "id" column definition by adding this property:
               checkboxSelection: true

            
            
           When finished, the column definition for the "id" column should look like this:
            
               {
                field: 'id',
                cellClass: 'grid-text-cell-format',
                cellRenderer: 'actionCellRenderer',
                cellRendererParams: {
                    deleteButtonGridMethod: (params: ICellRendererParams) => this.openDeleteDialog(params),
                    editButtonGridMethod: (params: ICellRendererParams) => this.openEditDialog(params)
                },
            
                headerName: '',
                filter: false,
                suppressMenu: true,
                sortable: false,
                checkboxSelection: true
            },



        c. Edit the gridOptions variable to allow users to check off multiple checkboxes
           -- Add this to the gridOptions:
                    rowSelection: 'multiple',    	// Possible values are 'single' and 'multiple'
            
            
           When finished, the gridOptions should look something like this:
            
              public gridOptions: GridOptions = {
                debug: true,
                suppressCellSelection: true,
                rowSelection: 'multiple',  	// Possible values are 'single' and 'multiple'
                domLayout: 'normal'
              };


    2. Verify that a checkbox appears in the id column
        a. Activate the debugger on "Full WebApp"
        b. Click on "Report Grid View"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image2.png)
```     
           NOTE:  Users can check multiple checkboxes.  
           If you press & hold shift while clicking, the grid will check all checkboxes in between



    3. Add a button to the top row (above the grid)
        a. Edit report-grid-view.component.html

        b. Add a new "button row" between the top row and 2nd row
            
            <!-- Start of the "button row" -->
            <div fxFlex  fxLayout="row" fxLayoutGap="5px">
            
                <!-- Left Side of the "button row"  -->
                <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="0">
            
                    <button mat-stroked-button color="primary" title="Update selected record">
                    <i class="far fa-user"></i>
                    Update
                    </button>
            
                </div>
            
            
                <!-- Right Side of the "button row" -->
                <div fxFlex fxLayoutAlign="end center">
            
                </div>
            
            </div>  <!-- End of "button row" -->


        c. Adjust the grid height so it starts 40 pixels down
           (increase the subtracted value to push down)

            Change this calculation:
                 <div style="height: calc(100vh - 130px);">
            
            To this:
                 <div style="height: calc(100vh - 170px);">




    4. Verify that button appears and only one vertical scrollbar appears
        a. Activate the debugger on "Full WebApp"
        b. Click on "Report Grid View"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image3.png)
```
The "Update" button appears above the grid.  And, the page has 1 vertical scrollbar (not two!)



    5. Change the "Update" button so it is disabled when no rows are selected
        a. Edit report-grid-view.component.ts

        b. Add a public numeric field called totalRowsSelected and initialize it to zero


    6. Have the button only be enabled if totalRowsSelected is greater than 0
        a. Edit report-grid-view.component.html

        b. Adjust the button so that it is enabled only if the totalRowsSelected > 0


    7. Verify that the button is disabled on page load  (as totalRowsSelected == 0)
        a. Activate the debugger on "Full WebApp"
        b. Click on "Report Grid View"
        c. Verify that the "Update" button is disabled on page load




    8. Have the grid update this variable when a user selects or un-selects rows
        a. Edit report-grid-view.component.ts

        b. Create a public method called userChangedGridSelection

              public userChangedGridSelection(): void {
                // Get the total number of rows that are selected
                this.totalRowsSelected = this.gridApi.getSelectedRows().length;
              }


        c. Edit report-grid-view.component.html

        d. Change the <ag-grid-angular> so that it will call our new method every time a user a changes a selection:

              (selectionChanged)="this.userChangedGridSelection()" 
   
        
        When finished, the <ag-grid-angular> tag should look like this:
        
        <!-- AG-Grid -->
        <ag-grid-angular
            style="width: 100%; height: 100%"
            class="ag-theme-alpine"
            [rowData]="this.rowData"
            [defaultColDef]="this.defaultColDefs"
            [columnDefs]="this.columnDefs"
            [gridOptions]="this.gridOptions"
            [frameworkComponents]="this.frameworkComponents"
            (selectionChanged)="this.userChangedGridSelection()"
            (gridReady)="this.onGridReady($event)">
        </ag-grid-angular>


    9. Verify that the button is enabled only when a user selects a grid
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Report Grid View"
        c. On page load, the "Update" button should be disabled  (as totalRowsSelected == 0)
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image4.png)
```



        d. Check off one or more rows and the "Update" button should be enabled
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image5.png)
```


    10. Adjust the button so that the button label shows "Update 6 Entries" (if 6 rows are selected)
        a. Edit report-grid-view.component.ts

        b. Add a public text field and initialize it to "Update"
            public updateButtonLabel

        c. Adjust the userChangedGridSelection() method so that it updates the button label
            
            If totalRowsSelected == 0, then set updateButtonLabel to "Update Entries"
            If totalRowsSelected == 1, then set updatebuttonLabel to "Update 1 Entry"
            If totalRowsSelected == 2 or more, then set updateButtonLabel to "Update N Entries"
            (where N is the actual number)



    11. Adjust the button so that the button text is not hard-coded as "Update" but instead uses this.updateButtonLabel
        a. Edit report-grid-view.component.html

        b. Change the button to use this.updateButtonLabel for the button text

        c. Change the button title=" " tag to show the same thing as the button text



    12. Verify that the button label changes as users select/unselect rows
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Report Grid View"
        c. On page load, the "Update" button should be disabled  (as totalRowsSelected == 0)
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image6.png)
```

        d. Check off a few rows and make sure the "Update" button has the correct grammar:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image7.png)
```


    13. Problem:  The button width changes as users select rows  (causing a "bump" effect)
        Solution:  Set the button width of the button to be 165px


        Approach 1:  Add style="width: 170px" to the update button
        Approach 2:  Add a CSS class called "grid-button" and assign it to the button using class="grid-button"


    14. Problem:  When the button shows "Update" it has lots of space
        Solution: Change the default button label from "Update" to "Update Entries"



    15. Problem the label "Update Entries" appears in 2 places (in the public string declaration and in userChangedGridSelection()
        Solution:  Remove the variable initial values and have the grid call userChangedGridSelection() when it's fully loaded
        a. Edit report-grid-view.component.ts

        b. Remove the initial values from totalRowsSelected and updateButtonLabel

        c. Have the onGridReady() method call userChangedGridSelection() when the grid is loaded

        d. Verify that the button shows "Update Entries" on page load (even though it's only defined in one place)


    16. Problem:  The method name userChangedGridSelection() is not really appropriate
        Solution:  Rename that method generateDerivedValuesOnUserSelection()
 

    17. Verify that the "Update" button looks good when 0, 1, or 2 rows are selected
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Report Grid View"
        c. On page load, the "Update Entries" button should be disabled  (as totalRowsSelected == 0)
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image8.png)
```


        d. When 1 row  is selected, it shows "Update 1 Entry"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image9.png)
```



        e. When multiple rows are selected, it shows "Update N Entries"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22g_image10.png)

