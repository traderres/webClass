Lesson 22a:  AG Grid / Client Side / Add to the Project
-------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1HDmu-lfcoXCWeoNfHm7B18jLGqUd3foyMzqFKO1urAA/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson22a/grid/add-to-project
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  My web app needs pages that show a grid and I need it to be fast<br>
Solution:  Add ag-grid to the project and configure it.

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22a_image1.png)


<br>
<br>

```
Community vs Enterprise Edition
-------------------------------
    • The community edition of ag-grid is good
    • If you're wise, you'll spend the money and get a license for the enterprise version
        (it has a number of improvements, including server-side infinity scrolling which make it worth it)


    Problem:   I want to try the Enterprise Edition
    Solution:  Send an email to info@ag-grid.com and ask for a trial license.
               They will response in a day and give you a 3-month enterprise license
    
    


Procedure
---------
    1. Install the NPM modules for ag-grid
       unix> cd ~/intellijProjects/angularApp1/frontend
       unix> npm install ag-grid-community  ag-grid-enterprise ag-grid-angular

        IF USING THE ENTERPRISE GRID, then use this command to install  
        (yes, you install ag-grid-community AND ag-grid-enterprise)



    2. Verify that your your package.json has these dependencies
        a. Edit angularApp1/frontend/package.json

        b. Make sure you see these values (or something close to it)
                "ag-grid-angular": "25.3.0",
                "ag-grid-community": "25.3.0",
                "ag-grid-enterprise": "25.3.0",
             
 

    3. Add the AgGridModule module
        a. Edit app.module.ts

        b. Add this to the imports section:

            imports: [ .... 	AgGridModule, .... ]

            
            WARNING:  If you add this to the wrong section, then you will lots of compiler errors!!!

    4. Add the CSS files for the ag-grid alpine theme
        a. Edit the angular.json

        b. Change the "styles": [  ] section so that it has these css files
          	"./node_modules/ag-grid-community/dist/styles/ag-grid.css",
          	"./node_modules/ag-grid-community/dist/styles/ag-theme-alpine.css",    

        When finished the "styles" section looks like this:
        	"styles": [
          	"./node_modules/@angular/material/prebuilt-themes/deeppurple-amber.css",
          	"./node_modules/@fortawesome/fontawesome-free/css/all.css",
          	"./node_modules/ag-grid-community/dist/styles/ag-grid.css",
          	"./node_modules/ag-grid-community/dist/styles/ag-theme-alpine.css",
          	"src/styles.css"
        	],   	

    5. Make sure your web app still compiles
        a. Delete this directory: the angluarApp1/frontend/node_modules directory

        b. In Intellij, Right-click on angularApp1/frontend/package.json -> Run Npm install

        c. In IntelliJ, activate your debugger on "Full WebApp"

        d. Make sure your webapp still comes-up on localhost:4200



    6. Create the grid page
        a. Add a new component called ReportGridView   (add it to the reports/ directory)


    7. Add security so that the reader and admin users can see the new grid page
        a. Add a constants for this page to constants.ts
            i. Edit constants.ts

            ii. Add this
                     REPORTS_GRID_VIEW_ROUTE = "page/reports/grid"

 
        b. Add the "page/reports/grid to the READER and ADMIN roles (on the back-end)
            i. Edit R__security.sql

            ii. Add a new record in the uicontrols table 
                     insert into uicontrols(id, name) values(1016, 'page/reports/grid');

            iii. Add record 1016 to the READER and ADMIN roles

            
            The route must be the SAME in both R__security.sql and constants.ts


        c. Verify that the R__security.sql script is valid by running flyway migrate manually
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:migrate
                 -- Verify that this finishes successfully with "BUILD SUCCESS"


        d. Verify that the READER role can see this new page
            i.   In IntelliJ, connect to your database console
            ii.  Run this SQL:

                    select distinct ui.name, true as access
                    from uicontrols ui
                            join roles r on (r.name IN ( 'READER' ))
                            join roles_uicontrols ru ON (r.id=ru.role_id) AND (ui.id=ru.uicontrol_id)
                    order by 1;

            iii. Verify that you see page/report/grid in the console with a checkbox next to it



        e.  Add route such that "page/reports/grid" --> ReportGridViewComponent
            i. Edit app.module.ts

            ii. Add a route for the ReportGridViewComponent


        f. Add a navbar entry for the Reports Grid View  (after Long View Report)
            i. Edit navbar.component.html

            ii. Add a navbar entry 
                NOTE:  Make sure you check if the user is allowed to see this route


        g. Adjust the navbar.component.ts so that the "Reports" navgroup is open by default
            i. Edit navbar.component.ts

            ii. Change these entries on the top to this:
                  public reportsNavGroupClosed: boolean = false;   // Open Reports on page load
                  public analyticsGroupClosed:  boolean = true;	// Close Analytics on page load


    8. Verify that the "Report Grid View" entry appears
        a. Activate the debugger on "Full WebApp"
        b. Verify that you see "Report Grid View"
        c. Verify that clicking on it shows a page
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22a_image2.png)
```
            You should see "Report Grid View" on the left



    9. Add the ag-grid options and sample data to the class
        a. Edit report-grid-view.component.ts

        b. Add these public variables:
            
                public defaultColDefs: any = {
                     flex: 1,
                     sortable: true,
                     filter: true,
                     floatingFilter: true,	// Causes the filter row to appear below column names
                 };
                
                     public columnDefs = [
                     {field: 'id' },
                     {field: 'name' },
                     {field: 'priority'},
                     {field: 'start_date'},
                     {field: 'end_date'}
                 ];
            
                 public rowData = [
                     { id: 1, name: 'Report 1', priority: 'low', 'start_date': '05/01/2019', 'end_date': '05/05/2019'},
                     { id: 2, name: 'Report 2', priority: 'medium', 'start_date': '06/01/2019', 'end_date': '06/06/2019'},
                     { id: 3, name: 'Report 3', priority: 'high', 'start_date': '07/01/2019', 'end_date': '07/07/2019'}
                 ];





    10. Add the grid to the page
        a. Edit report-grid-view.component.html

        b. Setup a page layout with 2 rows
           1st row holds the page title using the title of "Report Grid View"
           2nd row holds the mat-card

        c. The mat-card-content is setup to use the entire page

           HINT:  Take a look at some of your other pages and feel free to copy the layout
            


        d. Inside the mat-card-content, add the ag-grid:

            <!-- AG-Grid -->
            <ag-grid-angular
                 style="width: 100%; height: 100%"
                class="ag-theme-alpine"
                 [rowData]="this.rowData"
                [defaultColDef]="this.defaultColDefs"
                [columnDefs]="this.columnDefs">
            </ag-grid-angular>


        e. Adjust the mat-card tag so that it has margin=0 and padding=0

            
            
            IF YOU SEE NOTHING FOR YOUR GRID, GIVE IT SOME HEIGHT w/WRAPPER DIV:
            
            <div style="height: 450px">
            
                <!-- AG-Grid -->
                <ag-grid-angular
                     style="width: 100%; height: 100%"
                    class="ag-theme-alpine"
                     [rowData]="this.rowData"
                    [defaultColDef]="this.defaultColDefs"
                    [columnDefs]="this.columnDefs">
                </ag-grid-angular>
            
            </div>



    11. Verify that basic ag-grid appears in the page
        a. Activate your Debugger on "Full WebApp"
        b. Go to the "Reports Grid View"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22a_image3.png)
```
V1:  Simple grid with hard-coded data using the "alpine theme"



        c. Change the width of the page:  The grid should stretch along with it
NOTE:  If it does not, then you need a wrapper-div in the mat-card-content that does this using the calc() technique.



    12. What does the grid look like when we have 25 rows of data?  
        a. Edit report-grid-view.component.ts

        b. Modify the rowData by copying+pasting those 3 lines over a number of times

        c. Change the name so that you have "Report 1", "Report 2", "Report 3", "Report 4" ... "Report 25"

        d. Look at the grid in your debugger
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22a_image4.png)
```
Verify that your scrollbar fits inside the grid -- so that the column headers are always visible



    13. Change grid theme to "Alpine Dark"
        a. Edit angular.json

        b. Change this entry:
             "./node_modules/ag-grid-community/dist/styles/ag-theme-alpine.css",
        
           To this:
             "./node_modules/ag-grid-community/dist/styles/ag-theme-alpine-dark.css",
        



        c. Edit report-grid-view.component.html

        d. Change the ag-grid to use class="ag-theme-alpine-dark"
            
            When finished, the AG-Grid should look like this:
                <!-- AG-Grid -->
                <ag-grid-angular
                    style="width: 100%; height: 100%"
                    class="ag-theme-alpine-dark"
                    [rowData]="this.rowData"
                    [defaultColDef]="this.defaultColDefs"
                    [columnDefs]="this.columnDefs">
                </ag-grid-angular>



    14. Verify that your grid has a new look
        a. Activate the Debugger on "Full WebApp"     (NOTE:  You must restart the debugger)
        b. Click on "Report Grid View"
 ```
 ![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22a_image5.png)
 ```


NOTE:  Your grid comes with a number of provided themes including:
```
 ![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22a_image6.png)
 ```

Try a different theme and see which one you like.


```
