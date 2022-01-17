Lesson 11e:  View Reports / Improved Look & Feel / Angular Flex
---------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1_qBxHIxB-eM5l4K6wDzJVkz1pn4vIn__93wpns_JzyY/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson11e/angular-flex
<br>
<br>


  
  
<h3>Advantages of Angular Flex compared to an HTML Table</h3>

- It has more options for layouts -- e.g., more power
- It can "flex" with the page
- HTML table is designed for static grids -- i.e., grids that do not flex
- Independent of Angular Material -- i.e., you can use Angular Flex with any component library
- Does not depend on any external CSS requirements
- Provides a more robust grid than Bootstrap

  
<br>
<br>
<h3>Disadvantages of Angular Flex compared to HTML Table</h3>

- More complex -- takes more time to learn

  
<br>
<br>  
  
  


<h5>References</h5>

- https://tburleson-layouts-demos.firebaseapp.com/#/docs
- https://github.com/angular/flex-layout/wiki/API-Documentation
- https://github.com/angular/flex-layout/wiki/fxLayout-API

<br>
<br>  
  
  


```
Procedure
---------
    1. Change the View Reports to display the info in an Angular Flex table
        a. Edit view-reports.component.css

        b. Remove everything except odd-row and even-row

        c. Remove the text-align:center from the odd-row and even-row CSS classes

        d. Add these 2 CSS classes:
            
            .table-cell {
              padding: 5px;   /* table padding for regular cell */
              font-size: 110%;
              font-family: Roboto, "Helvetica Neue", sans-serif;
            }
            
            .header-cell {
              padding: 4px; 	/* table padding for header cell */
              font-size: 125%;
              font-weight: bolder;
              font-family: Roboto, "Helvetica Neue", sans-serif;
            }



    2. Change the View Reports HTML to show the info in an Angular Flex table
        a. Edit view-reports.component.html

        b. Replace your html with this:
            
            <ng-container *ngIf="(this.allReportsObs | async) as allReports">
            
                <!-- The REST call has come back with data.  So, display the page -->
                <mat-card>
            
                    <mat-card-title>View All Reports</mat-card-title>
            
                    <mat-card-content>
            
                        <div fxFlex fxLayout="column" fxLayoutGap="5px" fxLayoutAlign="start stretch" >
            
                            <!-- Show table headers -->
                            <div fxLayout="row" fxLayoutGap="0"  >
            
                                <div fxFlex="15%" fxLayoutAlign="center" >
                                        <!-- Report ID -->
                                        <span class="header-cell">ID</span>
                                </div>
            
                                <div fxFlex="25%" fxLayoutAlign="center">
                                        <!-- Report Name -->
                                        <span class="header-cell">Name</span>
                                </div>
            
                                <div fxFlex="10%" fxLayoutAlign="center">
                                        <!-- Report Priority -->
                                        <span class="header-cell">Priority</span>
                                </div>
            
                                <div fxFlex="15%" fxLayoutAlign="center">
                                        <!-- Report Start Date -->
                                        <span class="header-cell">Start Date</span>
                                </div>
            
                                <div fxFlex="15%" fxLayoutAlign="center">
                                        <!-- Report Start Date -->
                                        <span class="header-cell">End Date</span>
                                </div>
            
                            </div>	<!-- End of div that holds the fxFlex for this *HEADER ROW* -->
            
            
            
                            <!-- Loop through all of the reports -->
                            <ng-container *ngFor="let report of allReports;  let index = index">
            
                            <!-- Start a new row -->
                            <div fxLayout="row" fxLayoutGap="0"    [ngClass]="{
                                            'odd-row': 0 === index % 2,
                                            'even-row': 1 === index % 2 }"    >
            
                                    <div fxFlex="15%"  fxLayoutAlign="center">
                                        <!-- Report ID -->
                                        <span class="table-cell">{{report.id}}</span>
                                    </div>
            
                                    <div fxFlex="25%" fxLayoutAlign="center">
                                        <!-- Report Name -->
                                        <span class="table-cell">{{report.name}}</span>
                                    </div>
            
                                    <div fxFlex="10%" fxLayoutAlign="center">
                                        <!-- Report Priority -->
                                        <span class="table-cell">{{report.priority}}</span>
                                    </div>
            
                                    <div fxFlex="15%" fxLayoutAlign="center">
                                        <!-- Report Start Date -->
                                        <span class="table-cell">{{report.start_date}}</span>
                                    </div>
            
                                    <div fxFlex="15%" fxLayoutAlign="center">
                                        <!-- Report Start Date -->
                                        <span class="table-cell">{{report.end_date}}</span>
                                    </div>
            
                            </div>	<!-- End of div that holds the fxFlex for this *DATA ROW* -->
            
                            </ng-container>   <!-- End of looping through allReports -->
            
                    </div>
            
                    </mat-card-content>
            
                </mat-card>
            
            </ng-container>
            


    3. Verify it works
        a. Activate your Debugger 'Full WebApp'
        b. Go to the "View Reports" page
        c. Verify that you see the records in your database
```
![](https://lh6.googleusercontent.com/yg9ivrSkuWz_5QKpxmJs7cwiOIGjopPeDKXLx-FtNvow-G6f_9-pEu-Wih7OWXePym3VlLi12SL2gZbH_iVUV8QoYk9Wgcz72pKunF7cOOhq1FYqi9MkDErKX8yUzL1hHwIO9LM3)
```
View Reports v4  (using Angular Flex)



        d. Widen the browser
           -- You should see the column flex wider



```
