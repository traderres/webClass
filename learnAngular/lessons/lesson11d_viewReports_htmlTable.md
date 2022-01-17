Lesson 11d:  View Reports / Improved Look & Feel / HTML Table
-------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1jX8RL1jrvZULbcTj_QQQBccbR-VII-uwasQGw4bj6mA/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson11d/better-look-feel
<br>
<br>



<h3>Approach</h3>

- Show the data in an HTML table

<br>
<br>


```
Procedure
---------
     1. Change the View Reports to display the info in an HTML table
         a. Edit view-reports.component.css
 
         b. Adjust the existing CSS classes so that the info is centered
             i. Add this to the odd-row and even-row classes:
 	                text-align: center;
 
 
         c. Add these CSS classes:
                 
                 td {
                   padding: 5px;  		 /* table padding for regular cells */
                   font-size: 110%;
                   font-family: Roboto, "Helvetica Neue", sans-serif;
                 }
                 
                 th {
                   padding: 5px; 		/* table padding for header cells */
                   font-size: 125%;
                   font-weight: bolder;
                   font-family: Roboto, "Helvetica Neue", sans-serif;
                 }
                 
                 table {
                   border-collapse: separate;
                   border-spacing: 0;		    /* table cellspacing is zero so the row has no gaps */
                 }
                 
 
 
     2. Change the View Reports HTML to show the info in an HTML table
         a. Edit view-reports.component.html
 
         b. Replace your html with this:
                 
                 <ng-container *ngIf="(this.allReportsObs | async) as allReports">
                 
                    <!-- The REST call has come back with data.  So, display the page -->
                    <mat-card>
                 
                        <mat-card-title>View All Reports</mat-card-title>
                 
                        <mat-card-content>
                 
                                <table style="margin-top: 20px; width: 675px">
                                     <tr>
                                    <!-- Table Header -->
                                    <th style="width: 50px">ID</th>
                                    <th style="width: 250px">Name</th>
                                    <th style="width: 125px">Priority</th>
                                    <th style="width: 100px">Start Date</th>
                                    <th style="width: 100px">End Date</th>
                                   </tr>
                 
                                    <!-- Loop through all of the reports -->
                                    <ng-container *ngFor="let report of allReports;  let index = index" >
                 
                                           <!-- Add a row to the table -->
                                           <tr   [ngClass]="{ 'odd-row': 	0 === index % 2,
                                                                      'even-row':	1 === index % 2 }">
                                                <td>{{report.id}}</td>
                                                    <td>{{report.name}}</td>
                                                    <td>{{report.priority}}</td>
                                                    <td>{{report.start_date}}</td>
                                                    <td>{{report.end_date}}</td>
                                            </tr>
                                    </ng-container>
                                </table>
                 
                            </mat-card-content>
                    </mat-card>
                 </ng-container>
                 
 
     3. Verify it works
         a. Activate your Debugger 'Full WebApp'
         b. Go to the "View Reports" page
         c. Verify that you see the records in your database
 
```
![](https://lh6.googleusercontent.com/wrm32MVPIMLXIwnze6KlshKdu10lDnujgXj3xhME_hBEaIMHrIfdSf0FKhZJFY8dt1h2-4W63LoZaQn78uFEAJF7DQmPTtobX1cAYlz7RepUMEdJX4E0b1c_pZkAYPr6T6q559F6)
```
 View Reports v3  (using HTML table)
 
 
 



```
