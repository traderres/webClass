Lesson 12d:  Edit Report / Load Reactive Form w/data from REST Call
-------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1UHSj9Fa_VXQAr8XhqTHIjeWzFUGkmvxASiAeX-fMzRM/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson12d/load-reactive-form-with-data
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem: I want to use the Async pipe to invoke a REST call and initialize multiple fields  <br>
Solution: Create an observable and <b>tap into it</b>. The tap lets us listen for the data and run code<br>

<br><br>
In the past, we have used Async pipe like this:
- Async Pipe -> invoke REST call -> HTML page has data

<br>
  
Now, we want to use the Async pipe like this:  
- Async Pipe -> invoke REST call -> Tap into data to set form fields -> HTML page has data  

<br><br>

<h3>Approach</h3>

1. Create the front-end GetUpdateReportDTO class (this holds data for retrieved from the back-end)  

1. Add a method to the front-end ReportService.ts to get data for the Edit Report Page  

1. Add a formInfoObs to the page  
   ```
    public formInfoObs: Observable&lt;GetUpdateReportDTO>  
   ```

1. Add a method that takes the GetUpdateReportDTO object and populates the form fields  

1. The page's ngOnInit() initializes an observable and uses pipe and <b>tap</b> to get the info  

1. Have your html page subscribe and unsubscribe using the async pipe  
   ```
   <ng-container *ngIf="this.formInfoObs | async">
       <!-- Rest of the page -->
   </ng-container>
   ```

<br>
<br>

```

Procedure
---------
    1. Create the front-end GetUpdateReportDTO typescript class
        a. Create the class
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate class models/GetUpdateReportDTO --skipTests

        b. Add 3 public variables to GetUpdateReportDTO typescript class
            
            public id: number;
            public priority: number;   // holds the lookup value (not a string)
            public report_name: string;
            

    2. Add a method to the front-end ReportService.ts to get data for the Edit Report Page
        a. Edit report.service.ts

        b. Add this method:
            
              /*
               * Returns an observable that holds an array of GetUpdateReportDTO objects
               * NOTE:  This method is used by the "Edit Report" page to get info to load
               */
              public getEditReportInfo(aReportId: number): Observable<GetUpdateReportDTO> {
                // Construct the URL of the REST call
                const restUrl = environment.baseUrl + '/api/reports/update/get/' + aReportId;
            
                // Return an observable
                return this.httpClient.get <GetUpdateReportDTO>(restUrl);
              }
            



    3. Adjust the edit-report-component.ts so that it has a public observable with data
        a. Edit edit-report.component.ts


        b. Inject the ReportService in the constructor


        c. Add a public observable with the formInfo
            public formInfoObs: Observable<GetUpdateReportDTO>


        d. Add a method that takes the GetUpdateReportDTO object and populates the form fields
            
              /*
               * Populate the reactive form with data (retrieved from the back-end)
               */
              private populateFormFields(aData:  GetUpdateReportDTO) {
                this.myForm.controls.report_name.setValue(  aData.report_name );
                this.myForm.controls.priority.setValue( 	  aData.priority );
              }


        e. Add this to the end of your ngOnInit() to initialize an observable tap into it to get the info
            
            // Setup the observable so that the async pipe will subscribe and unsubscribe
            this.formInfoObs = this.reportService.getEditReportInfo(this.reportId).pipe(
              tap(  (aData: GetUpdateReportDTO) => {
                // The REST call came back.  Get the data before it hits the HTML page
            
                // Use the data to populate the form
                this.populateFormFields(aData);
              }));


    4. Have your html page subscribe and unsubscribe using the async pipe
        a. Edit edit.report.component.html

        b. Surround the HTML with this:
            
            <ng-container *ngIf="this.formInfoObs | async">
                <!-- The REST call came back.  So, display the page -->
            
            
            
                <!-- Rest of the page -->
            </ng-container>


    5. Verify that it works
        a. Add a breakpoint to your back-end ReportController.getInfoForEditReport() method
           Add a breakpoint in the populateFormFields() method (in edit-report.component.ts)
        b. Activate your Debugger -> Full WebApp
        c. Go to View Reports
        d. Click the "Edit" button
           -- Verify that your back-end ReportController breakpoint gets hit
        e. Press F9 to continue
           -- Verify that your front-end populateFormFields() method is called
        f. Press F9 to continue
           -- Verify that you see your "Edit Report" page loaded with data
```
![](https://lh4.googleusercontent.com/tsQa-7Z69FLWajLPv3PttPAs5y-47NLRNZWutO04FVILSF30k3-ntN1KrWurpuN-lEmQXqKUGGg5K1TO-MaMKmV8aqaEojR2lCe4JfGK6rg6w783-kd2m_XmudYnfBSWJOYgbIws)
```





    6. What happens if you change the url to use a reportId that is not in the database
-- e.g., http://localhost:4200/page/editReport/2000






    7. What happens if you change the url to have a reportId that is a string
-- e.g., http://localhost:4200/page/editReport/200bad







```
