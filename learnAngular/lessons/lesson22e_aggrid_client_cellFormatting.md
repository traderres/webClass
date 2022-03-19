Lesson 22e:  Ag Grid / Client Side / Cell Formatting using Cell Renderers
-------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/16Qi591eDDXeuI4WzzdrTJ1mCWdOWLlj6-hEK_g3aUik/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson22e/custom-cell-renderers
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem 1:  I want to apply CSS to a specific column cell<br>
Problem 2:  I want to display multiple values in a cell<br>
Problem 3:  I want to conditionally show CSS<br>
Problem 4:  I want to show a label with a different color (based on some value)<br>
<br>
Solution:   Make a custom cell renderer<br>





<br>
<br>
Custom Cell Renderer that displays the priority in a colorful rounded box.

![](https://github.com/traderres/webClass/raw/master/learnAngular/lessons/images/lesson21e_image1.png)

```
What is a Custom Cell?
----------------------
    • It's a regular angular component
    • It implements the ICellRendererAngularComp interface
    • It has access to the params object (which holds an entire row of data and more)
    • Registered using the frameworkComponents



Procedure:  Create a Custom Cell that Shows Different Colors
------------------------------------------------------------
    1. Create the custom cell renderer component
        a. Create a new component called priority-cell-custom-renderer  (inside the reports/report-grid-view directory)

        b. Edit priority-cell-custom-renderer.component.ts

        c. Change the class so it implements ICellRendererAngularComp

        d. Create the required methods to implement the ICellRendererAngularComp interface
            i. Put your cursor on the class name
            ii. Press Alt-Enter
            iii. Select Implement all required members
            iv. In the "Select Members to Implement", use the defaults and press OK


        e. Add a public variable called params:
              public params: ICellRendererParams

        f. Change the agInit() method so that it sets the class variable
              this.params = params




        g. Edit priority-cell-custom-render.component.html
            i. Replace its contents with this:
                
                <div style="padding: 5px">
                  <div [ngClass]="{
                        'priority-low-color':  	    this.params.data.priority == 'low',
                            'priority-medium-color':   this.params.data.priority == 'medium',
                            'priority-high-color': 	    this.params.data.priority == 'high',
                            'priority-critical-color':      this.params.data.priority == 'critical'
                        }">
                    {{params.value}}
                  </div>
                </div>



        h. Add these 4 styles to your styles.css
            
            NOTE:  At this point, I do not know if there is a performance difference if these files are located in priority-cell-custom-renderer.component.css
            
            
            .priority-low-color {
              text-align: center;
              font-family: 'Roboto';
              font-size: 1.1em;
              font-weight: 500;
              border-radius: 15px;
              background-color: #d8d8d8;
            }
            
            .priority-medium-color {
              text-align: center;
              font-family: 'Roboto';
              font-size: 1.1em;
              font-weight: 500;
              border-radius: 15px;
              background-color: #b2b2ff;
            }
            
            .priority-high-color {
              text-align: center;
              font-family: 'Roboto';
              font-size: 1.1em;
              font-weight: 500;
              border-radius: 15px;
              background-color: #ffffb2;
            }
            
            .priority-critical-color {
              text-align: center;
              font-family: 'Roboto';
              font-size: 1.1em;
              font-weight: 500;
              border-radius: 15px;
              background-color: #ffdcb2;
            }



    2. Register the custom cell renderer with your grid
        a. Edit report-grid-view.component.ts

        b. Create a map that holds all custom cell renderers
            
              // Tell ag-grid which cell-renderers will be available
              // This is a map of component names that correspond to components that implement ICellRendererAngularComp
              public frameworkComponents: any = {
                priorityCellRenderer: PriorityCellCustomRendererComponent,
              };


        c. Edit report-grid-view.component.html

        d. Change the <ag-grid-angular> tag so that this attribute is set:
             [frameworkComponents]="this.frameworkComponents"

        
        When finished, your <ag-grid-angular> tag should look something like this:
        
        <!-- AG-Grid -->
        <ag-grid-angular
          style="width: 100%; height: 100%"
          class="ag-theme-alpine"
          [rowData]="this.rowData"
          [defaultColDef]="this.defaultColDefs"
          [columnDefs]="this.columnDefs"
          [gridOptions]="this.gridOptions"
          [frameworkComponents]="this.frameworkComponents"
          (gridReady)="this.onGridReady($event)">
        </ag-grid-angular>
        
        



    3. Assign the custom cell renderer to a column
        a. Edit report-grid-view.component.ts

        b. Change the columnDefs so that the priority field uses the priorityCellRenderer

             {
                field: 'priority',
                cellRenderer: 'priorityCellRenderer'
             },

        
        When finished, your columnDefs should look like this:
        
          public columnDefs = [
            {
                field: 'id'
            },
            {
                field: 'name' },
            {
                field: 'priority',
                cellRenderer: 'priorityCellRenderer'
            },
            {
                field: 'start_date'
            },
            {
                field: 'end_date'
            }
          ];
        
        


    4. Verify the your "Priority" cell has a different color for each priority:
        a. Activate your Debugger on "Full WebApp"
        b. Click on "Report Grid View"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22e_image2.png)
```
Priority Cell V1:  Notice the bottom part of the cells is cut off   (that sucks!)



    5. Fix the problem with the buttons not taking the full height
        a. Edit report-grid-view.component.ts

        b. Change the priority column def by setting 
             autoHeight: true
        
        
        When finished, the priority column definition should look like this:
        
            {
                field: 'priority',
                cellRenderer: 'priorityCellRenderer',
                autoHeight: true
            },

    6. Verify that the Priority columns use the full height of the cell
        a. Activate your Debugger on "Full WebApp"
        b. Click on "Report Grid View"


```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22e_image3.png)
```
Priority Cell V2:  The priority cell looks good but the other cells are not vertically centered  
(we fixed one problem and created another.....Sucks again!!)

 
    7. Fix the problem with the other cells not vertically aligned
        a. Edit report-grid-view.component.ts

        b. Change all column definitions so that they they all have 
             autoHeight: true
        
        
        NOTE:  You have 2 approaches:
        
        Approach 1:  Add autoHeight: true to all columns in columnDef
        Approach 2:  Add autoHeight: true to the defaultColDefs

        
        
        When finished, the defaultColDefs object should look like this:
        
          public defaultColDefs: any = {
            flex: 1,
            sortable: true,
            filter: true,
            floatingFilter: true,	// Causes the filter row to appear below column names
            autoHeight: true
          };
        



    8. Verify that the other rows have the correct height
        a. Activate your Debugger on "Full WebApp"
        b. Click on "Report Grid View"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22e_image4.png)
```
Priority Cell V3:  Well that sucks!!  The fix did not work!!  This is known bug in ag-grid 25

    See https://www.ag-grid.com/ag-grid-pipeline/
    -- It is scheduled to be fixed in the future.
    
    So, what do we do?
       Option 1:  Wait for a bug fix
       Option 2:  Apply some CSS to those rows of text
    




    9. Adjust the ag-grid cells (that hold only text) so that they are vertically centered 
        a. Edit styles.css

        b. Add a CSS class called grid-text-cell-format

            .grid-text-cell-format {
              font-family: 'Roboto';
              font-size: 1.1em;
              font-weight: 400;
            
              margin-top: .25em;	/* Fixes the bug with autoHeight not working in the ag-grid */
            }


        c. Edit report-grid-view.component.ts

        d. Adjust the autoHeight so it is true only for the priority column

        e. Apply this new CSS class to these columns:  'id', 'name', 'start_date', 'end_date'
           by adding this to the column definition:

                cellClass: 'grid-text-cell-format'

        
        When finished, the column definitions should look something like this:
        
         public columnDefs = [  
            {
                field: 'id',
                cellClass: 'grid-text-cell-format'
            },
            {
                field: 'name',
                cellClass: 'grid-text-cell-format'
            },
            {
                field: 'priority',
                cellRenderer: 'priorityCellRenderer',
            },
            {
                field: 'start_date',
                cellClass: 'grid-text-cell-format'
            },
            {
                field: 'end_date',
                cellClass: 'grid-text-cell-format'
            }    ];



    10. Verify the fix works
        a. Activate your Debugger on "Full WebApp"
        b. Click on "Report Grid View"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22e_image5.png)
```
Priority Cell V4:  Much better!  But, we will have to remove the CSS fix at some point

    
    
    
    If we upgrade the ag-grid, then we will need to remove the margin-top from this CSS class:
    
    .grid-text-cell-format {
      font-family: 'Roboto';
      font-size: 1.1em;
      font-weight: 400;
    
      margin-top: .25em;	/* Fixes the bug with autoHeight not working in the ag-grid */
    }


```
