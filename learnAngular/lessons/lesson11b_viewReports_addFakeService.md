Lesson 11b:  View Reports / Add Front End Page / Fake Service
-------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/11SMA-tOAXGi0Z-H9YpqVynKEVpUCyJCfvFlyG-RJ8E8/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson11b/frontend-service-hardcoded
<br>
<br>


<h3>Approach</h3>

- Create the front-end GetReportDTO TypeScript class  
  It holds these fields:  id, name, priority, startDate, and endDate
    
- Add a public method to the ReportService called getAllReports() that  
  returns an observable holding a hard-coded array of GetReportDTO objects  
    
- Inject the ReportService into the view-reports.components.ts  

- In the view-reports.component.ts ngOnInit(), invoke the ReportService.getAllReports()  
  So, we have an observable that holds the array of GetReportDTO objects  
    
- In the view-reports.component.html, use the Async Pipe to display the array of objects  
    
- Make the view-reports.component.html look better

  
<br>
<br>

```

Procedure
---------
     1. Create the GetReportDTO front-end class
         a. Generate the class
            unix> cd ~/intellijProjects/angularApp1/frontend
            unix> ng generate class models/GetReportDTO --skipTests 
 
         b. Replace the class with this:
             
             export class GetReportDTO {
               public id: number;
               public name: string;
               public priority: string;
               public start_date: string;
               public end_date: string;
             }
             
 
     2. Add a public method to the ReportService called getAllReports()
         a. Edit report.service.ts
 
         b. Add this method:
             
               /*
                * Returns an observable that holds an array of GetReportDTO objects
                */
               public getAllReports(): Observable<GetReportDTO[]> {
                let data: GetReportDTO[] = [
                {
                        id: 1,
                        name: 'Report 1',
                        priority: 'Low',
                        start_date: '01/05/2020',
                        end_date: '12/31/2020'
                },
                {
                        id: 2,
                        name: 'Report 2',
                        priority: 'Critical',
                        start_date: '11/17/2020',
                        end_date: '05/11/2021'
                },
                {
                        id: 3,
                        name: 'Report 3',
                        priority: 'High',
                        start_date: '11/09/2019',
                        end_date: '04/25/2021'
                }
                ];
             
                return of(data);
               }
             
             
 
     3. Adjust the View Reports Component.ts to use the ReportService
         a. Edit view.reports.component.ts
 
         b. Inject the ReportService into the constructor
 
         c. Add a public observable variable:
               public allReportsObs: Observable<GetReportDTO[]>;
 
         d. Edit the ngOnInit() to call your reportService:
 
               public ngOnInit(): void {
                // Get an observable to the REST call that will retrieve all reports
                // NOTE:  The Async Pipe will subscribe and unsubscribe from this automatically
                this.allReportsObs = this.reportService.getAllReports();
               }
             
 
 
 
     4. Adjust the View Reports Component.html to display the information from allReportsObs
         a. Edit view.reports.component.html
 
         b. Replace its contents with this:
             
             <ng-container *ngIf="(this.allReportsObs | async) as allReports">
                <!-- The REST call has come back with data.  So, display the page -->
                <mat-card>
             
                    <mat-card-title>View All Reports</mat-card-title>
             
                    <mat-card-content>
             
                            <!-- Loop through all of the reports -->
                            <ng-container *ngFor="let report of allReports">
             
                            <p>
                                {{report.id}} {{report.name}} {{report.priority}} {{report.start_date}} {{report.end_date}}
                            </p>
             
                            </ng-container>
             
                    </mat-card-content>
             
             
                </mat-card>
             
             </ng-container>
             
 
 
     5. Verify it works
         a. Activate the debugger for 'Full WebApp"
         b. Go to the "View Reports" page
            You should see something like this:  (Yes, it looks bad)
```
![](https://lh6.googleusercontent.com/IEYihPWLdDgoXpWKXVGj0j1ArUEJbUkcGMh7IOC-MayjKbbWHlgh7Nx-bz8rBVGm11j5jWWoBBFyBcphN-gnxWkKczkvk5oEPnxq-E6KvqjTNuzjg2Q2E4ZsVVkXOeiIVds6ZlE3)
```
View Reports v1  (looks ugly!)


 
 NOTE:  If your Reports database table has no data, then run this SQL to get some data:
 
 insert into reports(id, version, name, priority) values(1, 1, 'Report 1', 1);
 insert into reports(id, version, name, priority) values(2, 1, 'Report 2', 2);
 insert into reports(id, version, name, priority) values(3, 1, 'Report 3', 3);
 


 
Part 2:  Make the Web Page Look Better  (View Report v2)
--------------------------------------------------------
Yes, the web page looks bad.  Let's make it more professional.
 
     1. Add CSS classes for odd and even rows to your view-reports.component.css
         a. Edit view-reports.component.css
 
         b. Add these 2 css classes:
             .odd-row {
               background-color: #e8f4fe;
               padding: 8px;
             }
             
             .even-row {
               background-color: inherit;
               padding: 8px;
             }
                 
 
 
     2. Use Angular Flex to create a table layout
         a. Edit view-reports.component.html
 
         b. Change the html to this:
             
             <ng-container *ngIf="(this.allReportsObs | async) as allReports">
             
                  <!-- The REST call has come back with data.  So, display the page -->
                  <mat-card>
             
                    <mat-card-title>View All Reports</mat-card-title>
             
                    <mat-card-content>
             
                        <!-- Loop through all of the reports -->
                        <ng-container *ngFor="let report of allReports;  let index = index" >
             
                        <div fxLayout="row" fxLayoutGap="0"   fxLayoutAlign="center center"
                                [ngClass]="{ 'odd-row': 	0 === index % 2,
                                                      'even-row':	1 === index % 2 }">
             
                            <p>
                                {{report.id}} {{report.name}} {{report.priority}} {{report.start_date}} {{report.end_date}}
                            </p>
             
                        </div>
             
                        </ng-container>
             
                    </mat-card-content>
             
                </mat-card>
             
             </ng-container>
 
 
 
     3. Try it out
         a. Activate your debugger on 'Full WebApp
         b. Go to "View Reports"
 ASSUMPTION:  You have a few records in your Reports database table
 
 You should see this:
```
![](https://lh4.googleusercontent.com/j_GHWc1HV7ZdKqKWacbe_pUCt_mT6f6BRfm9ZB2oGTMgJcWBjBkBQvi-HugMlFL3EtXcG-nJj_KmZnIzeCLQjePjeoMbq4ppV03iqVmQByuofBjfGghOl6Qy9VUWAC7rzuQMIw4m)
```
View Reports v2
 



```
